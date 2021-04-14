#############
# Build stage
#############
FROM golang:1.16-buster as build

WORKDIR /src
COPY go.mod .
RUN go mod download
RUN go mod verify
COPY . .
RUN go build -ldflags '-w -s' -o /out/example-app .

#############
# Run stage
#############
FROM golang:1.16-buster
COPY --from=build /out/example-app /
ENTRYPOINT ["/example-app"]