package main

import (
	"bytes"
	_ "embed"
	"flag"
	"fmt"
	"html/template"
	"log"
	"math"
	"math/rand"
	"net/http"
	"os"
	"os/exec"
	"runtime"
	"strconv"
	"strings"
	"time"
)

type IndexResponse struct {
	InstanceID string
}

var (
	//go:embed html/index.html
	indexPageEmbed string
	indexTemplate  = template.Must(template.New("index").Parse(indexPageEmbed))
	mode           = flag.String("mode", "server", "Run a 'server' or 'job'")

	// server flags
	listenAddr = flag.String("listen-addr", ":8080", "The address to listen on for HTTP requests.")
	maxPrimes  = flag.Int("server-max-primes", 1_000_000, "Set max primes to calculate when exhausting CPU.")

	// job flags
	jobMinSleep   = flag.Int("job-min-sleep", 0, "Set a minimum sleep time for the job to illustrate timeouts. All jobs have up to 3 additional seconds added.")
	jobForceFail  = flag.Bool("job-force-fail", false, "Force the job to fail.")
	jobResult     = "succeed"
	jobExitStatus = 0

	// other
	memoryLeakBucket = ""
)

func init() {
	rand.Seed(time.Now().UnixNano())
}

func main() {
	flag.Parse()
	fmt.Printf("Running in %s mode\n", *mode)

	switch *mode {
	case "job":
		startJob()
	default:
		startServer()
	}
}

func startServer() {
	http.HandleFunc("/", indexHandler)
	http.HandleFunc("/crash", crashHandler)
	http.HandleFunc("/cpu", cpuHandler)
	http.HandleFunc("/memory", memoryHandler)

	fmt.Printf("Instance %s listening on %s\n", getInstanceId(), *listenAddr)
	log.Fatal(http.ListenAndServe(*listenAddr, nil))
}

func startJob() {
	seconds := *jobMinSleep + rand.Intn(3)

	if *jobForceFail {
		jobResult = "fail"
		jobExitStatus = 1
	}

	for {
		if seconds <= 0 {
			break
		} else {
			fmt.Printf("Job should %s in %d seconds\n", jobResult, seconds)
			time.Sleep(1 * time.Second)
			seconds--
		}
	}

	os.Exit(jobExitStatus)
}

func indexHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Handling /")
	assigns := IndexResponse{
		InstanceID: getInstanceId(),
	}

	w.WriteHeader(200)
	indexTemplate.Execute(w, assigns)
}

func crashHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Crashing the app...")
	os.Exit(1)
}

func memoryHandler(w http.ResponseWriter, r *http.Request) {
	var m runtime.MemStats
	fmt.Println("Handling /memory")
	memoryLeakBucket = memoryLeakBucket + exhaustMemory()
	runtime.ReadMemStats(&m)

	output := fmt.Sprintf("Alloc = %v MiB\n", bToMb(m.Alloc))
	output = output + fmt.Sprintf("TotalAlloc = %v MiB\n", bToMb(m.TotalAlloc))
	output = output + fmt.Sprintf("Sys = %v MiB\n", bToMb(m.Sys))

	w.Write([]byte(output))
}

func cpuHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Println("Handling /cpu")
	primes := exhaustCpu()
	output := []byte(strings.Join(primes, ","))
	w.Write(output)
}

func exhaustMemory() string {
	// read a bunch of bytes
	numBytes := strconv.Itoa(25_000_000)
	cmd := exec.Command("head", "-c", numBytes, "/dev/urandom")

	var out bytes.Buffer
	cmd.Stdout = &out

	err := cmd.Run()

	if err != nil {
		log.Fatal(err)
	}

	return out.String()
}

func exhaustCpu() []string {
	currentNumber := 2
	primes := []string{}

	for len(primes) <= *maxPrimes {
		if isPrime(currentNumber) {
			primes = append(primes, strconv.Itoa(currentNumber))
		}

		currentNumber++
	}

	return primes
}

func isPrime(value int) bool {
	for i := 2; i <= int(math.Floor(float64(value)/2)); i++ {
		if value%i == 0 {
			return false
		}
	}
	return value > 1
}

func bToMb(b uint64) uint64 {
	return b / 1024 / 1024
}

func getInstanceId() string {
	if value, ok := os.LookupEnv("INSTANCE_ID"); ok {
		return value
	}
	return "(not-set)"
}
