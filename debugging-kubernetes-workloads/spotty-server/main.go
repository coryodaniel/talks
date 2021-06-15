package main

import (
	"flag"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
)

var jankyMode = flag.Bool("janky", false, "Make the app extra janky.")

func handler(w http.ResponseWriter, r *http.Request) {
	path := r.URL.Path[0:]
	status := http.StatusOK
	messageTemplate := "Handled request %s%s"

	if r.URL.Path[1:] == "spotty" {
		if rand.Intn(10) < 8 {
			messageTemplate = "Spotty request %s%s"
			status = http.StatusInternalServerError
		}
	}

	w.WriteHeader(status)
	fmt.Printf("[GET] %d %s\n", status, path)
	fmt.Fprintf(w, messageTemplate, listenAddr(), path)
}

func main() {
	flag.Parse()

	http.HandleFunc("/", handler)
	fmt.Printf("Starting server on %s\n", listenAddr())

	if *jankyMode {
		fmt.Println("Something janky happened!")
		os.Exit(1)
	} else {
		log.Fatal(http.ListenAndServe(listenAddr(), nil))
	}
}

func listenAddr() string {
	addr := getAddr()
	port := getPort()

	return addr + ":" + port
}

func getAddr() string {
	addr := os.Getenv("SPOTTY_ADDR")

	// internally to the go server, 0.0.0.0 isn't a valid ipv4 address, so it won't actually accept it, it needs a
	// blank host to simulate 0.0.0.0
	if addr == "0.0.0.0" {
		addr = ""
	}

	return addr
}

func getPort() string {
	port := os.Getenv("SPOTTY_PORT")

	if port == "" {
		port = "8080"
	}

	return port
}
