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
#### this is not suitable for production since the server has no authentication
#### ----------

### run the Gin on linux (goos=linux)
```  
gi clone https://github.com/rsnullptr/vpngw-simple-server.git
cd vpngw-simple-server
go build

./vpngw-server --help
Usage of ./vpngw-server:
  -crt string
        ssl crt file
  -key string
        ssl key file
  -port int
        port to serve (default 9090)

./vpngw-server --port 9043 --crt sslcert/some.crt --key sslcert/some.key

note: if no port is provided the hardocded one is used, check main.go
```

#### What's setup folder?
well... is the setup folder actually. 
```
.setup/setup.sh: only ready for ubuntu server.
.setup/vpngw-server.service: systemd like service
.setup/prebuilt/: pre builded executables

.sslcert/genself.sh: to generate self signed certs if you want - required openssl

note: due to iptables configurations, vpn interfaces must start with tunX, therefore, wg config shal be renamed to: tunXPTO.conf
example: 
    for:  /etc/wireguard/tun_pt.conf
    execute: curl localhost:9090/wg/tun_pt
    result: ip a 
            9: tun_netflix: <POINTOPOINT,NOARP,UP,LOWER_UP>....
```

#### How to use it? 
```  
curl localhost:9090/list -> will show all the endpoints. 

curl localhost:9090/wg/tunX -> will start vpn and kill previous ones, on conf tunX
```

#### Pre built executables
```
env GOOS=linux GOARCH=arm GOARM=7 go build
env GOOS=linux GOARCH=arm GOARM=6 go build
env GOOS=linux go build 
env GOOS=darwin go build
env GOOS=windows go build   
```
