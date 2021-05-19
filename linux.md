# C
## Cloud 9
### install
```
npm install forever
git clone https://github.com/c9/core.git ~/c9sdk
cd c9sdk
scripts/install-sdk.sh
```

### run

```
forever start ~/c9sdk/server.js -w ~/ --auth user:pass --collab -l 8181
```

# D

# L
## Latex-texlive

[Overleaf official guide](https://github.com/overleaf/overleaf/wiki/Quick-Start-Guide)

### overleaf docker

```
wget https://raw.githubusercontent.com/overleaf/overleaf/master/docker-compose.yml
docker compose up
```

### change CTAN mirror

```
tlmgr option repository http://mirrors.aliyun.com/CTAN/systems/texlive/tlnet/ 
```

### upgrade texlive distribution

```
docker exec -it sharelatex bash 
cd /usr/local/texlive 
cp -a 2020 2021
wget http://mirror.ctan.org/systems/texlive/tlnet/update-tlmgr-latest.sh
sh update-tlmgr-latest.sh -- --upgrade 
tlmgr update --self --all 
luaotfload-tool -fu 
```

### install full texlive 

```
docker exec sharelatex tlmgr install scheme-full
docker commit sharelatex sharelatex/sharelatex:with-texlive-full
```

### add user

```
docker exec sharelatex /bin/bash -c "cd /var/www/sharelatex; grunt user:create-admin --email=example@example.com"
```

# N

## netstat

### show listening 

```
sudo netstat -tunlp
```

### show gateway

```
sudo netstat -rn
```

# T

## tun2socks

### use a linux server as gateway for all local devices

[https://www.ghl.name/archives/how-to-use-tun2socks-to-set-up-global-proxy-on-linux.html]
```
# installation
git clone https://github.com/ambrop72/badvpn.git
cd badvpn/
mkdir build
cd build
cmake ..
make -j
sudo make install

# ip forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
ip tuntap add dev tun2 mode tun
ifconfig tun2 192.168.168.0/24 netmask 255.255.255.0
route add default gw 192.168.168.2
iptables -t nat -A POSTROUTING ! -d 192.168.123.0/24 -o tun2 -j MASQUERADE

# tun2socks launch
badvpn-tun2socks --netif-ipaddr 192.168.168.2 --netif-netmask 255.255.255.0 --socks-server-addr "192.168.123.100:7890" --tundev "tun2" --socks5-udp --udpgw-transparent-dns
```


# X

## X11

### Client side
```
# ~/.ssh/config
Host *
  ForwardAgent yes
  ForwardX11 yes
```

### Server side

```
sudo apt-get install xauth
```

## xargs

### escape quote sign

```
find . -print0 -type f| xargs -0 ...
find . -type f| xargs -d "\n"
```

# Z

## ZeroTier

## Moon server

```
curl -s https://install.zerotier.com/ | sudo bash
sudo systemctl start zerotier-one.service
sudo systemctl enable zerotier-one.service
sudo zerotier-cli join $NETWORK_ID

cd /var/lib/zerotier-one
sudo zerotier-idtool initmoon identity.public |sudo tee moon.json
sudo sed -i 's/"stableEndpoints": \[\]/"stableEndpoints": ["0.0.0.0\/9993"]/g' moon.json
zerotier-idtool genmoon moon.json

sudo mkdir moons.d
sudo mv *.moon moons.d 
sudo systemctl restart zerotier-one
```

```
curl -s https://install.zerotier.com/ | sudo bash
sudo systemctl start zerotier-one.service
sudo systemctl enable zerotier-one.service
sudo zerotier-cli join $NETWORD_ID
sudo zerotier-cli orbit $MOON_ID $MOON_ID
sudo zerotier-cli listpeers
```