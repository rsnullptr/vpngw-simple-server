# vpngw-simple-server
A simple Gin Gonic Server to manage vpn gw

#### what's a vpn gateway?
A simple node in our network that allow us to forward traffic
via a vpn.
That same node will work as gateway for other instances in the network

#### Thanks to:
```
.Gin Gonic: https://github.com/gin-gonic 
.Golang: https://golang.org
```

### Purpose
This little restfull server has the only purpose to allow a noob user to switch between VPN 
configuration without concerning about the how to linux style.

#### ----------
#### this is not suitable for production since the server has no ssl nor authentication
#### ----------

### run the Gin on linux (goos=linux)
```  
cd $GOPATH
gi clone https://github.com/rsnullptr/vpngw-simple-server.git
cd vpngw-simple-server
go build
./vpngw-server 80

note: if no port is provided the hardocded one is used, check main.go
```

#### What's setup folder?
well... is the setup folder actually. 
```
.setup/setup.sh: only ready for ubuntu server.
.setup/vpngw-server.service: systemd like service
.setup/prebuilt/: pre builded executables
```

#### Pre built executables
```
env GOOS=linux GOARCH=arm GOARM=7 go build
env GOOS=linux GOARCH=arm GOARM=6 go build
env GOOS=linux go build 
env GOOS=darwin go build
env GOOS=windows go build   
```
