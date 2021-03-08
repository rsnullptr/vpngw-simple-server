package main

import (
	"flag"
	"github.com/gin-gonic/gin"
	"log"
	"os"
)

var endpoints map[string]gin.HandlerFunc

func init() {
	endpoints = map[string]gin.HandlerFunc{
		"stop":       Stop,
		"speedtest":  Speedtest,
		"list":       List,
		"sysstats":   SysStats,
		"ovpn/:conf": StartOpenVpn,
		"wg/:conf":   StartWgVpn,
	}
}

func main() {
	port := flag.Int("port", 9090, "port to serve")
	certFile := flag.String("crt", "", "ssl crt file")
	keyFile := flag.String("key", "", "ssl key file")
	flag.Parse()

	logger := log.New(os.Stderr, "", 0)
	logger.Println("Starting Vpngw Server.")

	engine := NewEngine()
	SetEndpoints(engine, &endpoints)
	StartListening(engine, "", *port, *certFile, *keyFile)
}
