package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"os"
	"strconv"
)

var endpoints map[string]gin.HandlerFunc

func init() {
	endpoints = map[string]gin.HandlerFunc{
		"stop":           Stop,
		"speedtest":      Speedtest,
		"defaultdefault": DefaultVpn,
		"list":           List,
		"sysstats":       SysStats,
		"ovpn/:conf":     StartOpenVpn,
		"wg/:conf":       StartWgVpn,
	}
}

func main() {
	port := 9090
	if len(os.Args) > 1 {
		port, _ = strconv.Atoi(os.Args[1])
	}

	logger := log.New(os.Stderr, "", 0)
	logger.Println("Starting Vpngw Server.")

	for key, _ := range endpoints {
		logger.Println(key)
	}

	engine := NewEngine()
	SetEndpoints(engine, &endpoints)
	StartListening(engine, "", port, "selfcerts/server.crt", "selfcerts/server.key")
}
