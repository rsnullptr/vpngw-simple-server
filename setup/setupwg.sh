## ubuntu
add-apt-repository ppa:wireguard/wireguard
apt-get update -y
apt-get install resolvconf wireguard-dkms wireguard-tools linux-headers-$(uname -r) -y
