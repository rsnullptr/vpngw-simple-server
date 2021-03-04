#!/bin/bash -e 
while : ; do
    echo "have you installed wireguard? (y/n)"
    read -n 1 k <&1
    if [[ $k = y ]] ; then
        printf "\nOK, nice. lets deal with openvpn...\n"
        break
    else
        printf "\nWhat are you waiting? i'll do it... \n"
        ./setupwg.sh
    fi
done

sudo apt-get install -y openvpn iptables-persistent netfilter-persistent dnsmasq speedtest-cli 
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p  

echo "Insert network interface name <max 5 chars> <press enter>:"
read INTERFACE <&1
   
sudo iptables --flush &&
sudo iptables --delete-chain &&
sudo iptables -t nat -F &&
sudo iptables -t nat -A POSTROUTING -o tun+ -j MASQUERADE &&
sudo iptables -A INPUT -i $INTERFACE -p tcp --dport 22 -j ACCEPT &&
sudo iptables -A INPUT -i lo -m comment --comment "loopback" -j ACCEPT &&
sudo iptables -A OUTPUT -o lo -m comment --comment "loopback" -j ACCEPT &&
sudo iptables -I INPUT -i $INTERFACE -m comment --comment "In from LAN" -j ACCEPT &&
sudo iptables -I OUTPUT -o tun+ -m comment --comment "Out to VPN" -j ACCEPT &&
sudo iptables -A OUTPUT -o $INTERFACE -p udp --dport 1198 -m comment --comment "openvpn" -j ACCEPT &&
sudo iptables -A OUTPUT -o $INTERFACE -p udp --dport 123 -m comment --comment "ntp" -j ACCEPT &&
sudo iptables -A OUTPUT -p UDP --dport 67:68 -m comment --comment "dhcp" -j ACCEPT &&
sudo iptables -A OUTPUT -o $INTERFACE -p udp --dport 53 -m comment --comment "dns" -j ACCEPT &&
sudo iptables -A FORWARD -i tun+ -o $INTERFACE -m state --state RELATED,ESTABLISHED -j ACCEPT &&
sudo iptables -A FORWARD -i $INTERFACE -o tun+ -m comment --comment "LAN out to VPN" -j ACCEPT &&
sudo iptables -A FORWARD -i $INTERFACE -o $INTERFACE -m comment --comment "LAN out to LAN executed if tun+ is down" -j ACCEPT &&
sudo iptables  -P FORWARD DROP

sudo netfilter-persistent save
sudo systemctl enable netfilter-persistent


while : ; do
    echo "All .conf files are in /etc/openvpn? (y/n)"
    read -n 1 k <&1
    if [[ $k = y ]] ; then
        printf "\nOK, nice. let's make some changes...\n"
        break
    else
        printf "\nWhat are you waiting? I need to change them..\n"
    fi
done

cd /etc/openvpn/
sudo find -iname "*.conf" -exec bash -c 'echo "script-security 2" >> {}' \;
sudo find -iname "*.conf" -exec bash -c 'echo "up /etc/openvpn/update-resolv-conf" >> {}' \;
sudo find -iname "*.conf" -exec bash -c 'echo "down /etc/openvpn/update-resolv-conf" >> {}' \;   


while : ; do
    echo "copied folder to /opt ? (y/n)"
    read -n 1 k <&1
    if [[ $k = y ]] ; then
        printf "\nOK, nice. let's enable the service. \n"
        break
    else
        printf "\nWhat are you waiting? I will do it...\n"
        sudo cp -r ../../vpngw-simple-server /opt/vpngw-simple-server
        sudo cp vpngw-server.service /etc/systemd/system/vpngw-server.service
        printf "copied. don't forget to change the service executable. do it and answer [y]... "
    fi
done

sudo systemctl enable vpngw-server;

while : ; do
    echo "everything is done. urrayy... i need to reboot, may I? (y/n)"
    read -n 1 k <&1
    if [[ $k = y ]] ; then
        printf "\nOK, cya.\n"
        sudo reboot
        break
    else
        printf "\nThat's pretty sad...\n"
        printf "\n at least reboot me manually... cya"
        break
    fi
done
