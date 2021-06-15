ARG RUN_IMG=gcr.io/distroless/base
#############
# Build stage
#############
FROM golang:1.16-buster as build

WORKDIR /src
COPY go.mod .
RUN go mod download
RUN go mod verify
COPY . .
RUN go build -ldflags '-w -s' -o /out/spotty-server .

#############
# Run stage
#############
FROM $RUN_IMG
COPY --from=build /out/spotty-server /
ENTRYPOINT ["/spotty-server"]