package main

import (
	"github.com/gin-gonic/gin"
	"log"
	"os/exec"
)

// specific endpoints
func Stop(c *gin.Context) {
	xmd(c, "scripts/stop", "stop")
	where(c)
}

func Speedtest(c *gin.Context) {
	xmd(c, "scripts/speedtest", "speedtest")
	where(c)
}

func DefaultVpn(c *gin.Context) {
	c.Params = append(c.Params, gin.Param{Key: "conf", Value: "tun_raf"})
	StartWgVpn(c)
	where(c)
}

func List(c *gin.Context) {
	xmd(c, "scripts/list", "list")
	c.Writer.WriteString("\n available endpoints: ")
	for i, _ := range endpoints {
		c.Writer.WriteString("\n" + i)
	}
	where(c)
}

func SysStats(c *gin.Context) {
	xmd(c, "scripts/stats", "stats")
	where(c)
}

func StartOpenVpn(c *gin.Context) {
	xmd(c, "scripts/startovpn", "startovpn", c.Params.ByName("conf"))
	where(c)
}
func StartWgVpn(c *gin.Context) {
	xmd(c, "scripts/startwg", "startwg", c.Params.ByName("conf"))
	where(c)
}

//private
type writer struct {
	c   *gin.Context
	ctx string
}

func (T writer) Write(bytes []byte) (int, error) {
	log.Println("Std"+T.ctx+": ", string(bytes))
	res, err := T.c.Writer.Write(bytes)
	T.c.Writer.Flush() //write it out to the browser
	return res, err
}

func xmd(c *gin.Context, path string, args ...string) {
	outWriter := writer{c: c, ctx: "out"}
	errWriter := writer{c: c, ctx: "err"}
	cmd := exec.Cmd{
		Path:   path,
		Args:   args,
		Stdout: outWriter,
		Stderr: errWriter,
	}

	cmd.Run()
}

func where(c *gin.Context) {
	c.Writer.WriteString("\n\n")
	xmd(c, "scripts/where", "where")
}
