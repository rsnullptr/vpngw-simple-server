package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"strconv"
)

func NewEngine() *gin.Engine {
	return gin.Default()
}

func SetEndpoints(engine *gin.Engine, endpoints *map[string]gin.HandlerFunc) {
	for key, value := range *endpoints {
		engine.GET("/"+key, requestBegin, value, requestEnd) //its all GET to be used directly from browser url
	}
}

func StartListening(engine *gin.Engine, host string, port int) {
	engine.Run(host + ":" + strconv.Itoa(port))
}

//private

func requestBegin(c *gin.Context) {
	log.Println("##### RequestBegin ###### ")
	log.Print(c)
}

func requestEnd(c *gin.Context) {
	log.Print(c)
	log.Println("##### RequestEnd ###### ")
}
