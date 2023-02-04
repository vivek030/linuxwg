#!/bin/bash
set -e

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, this script must be ran as root"
	echo "Maybe try this:"
	echo "curl https://raw.githubusercontent.com/wg-dashboard/wg-dashboard/master/install_script.sh | sudo bash"
	exit
fi

# i = distributor id, s = short, gives us name of the os ("Ubuntu", "Raspbian", ...)
if [[ "$(lsb_release -is)" == "Raspbian" ]]; then
	# needed for new kernel
	apt-get update -y
	apt-get upgrade -y

	# install required build tools
	apt-get install -y raspberrypi-kernel-headers libmnl-dev libelf-dev build-essential 
	cd /opt
	# get the latest stable snapshot
	curl -L https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190601.tar.xz --output WireGuard.tar.xz
	# create directory
	mkdir -p WireGuard
	# unzip tarball
	tar xf WireGuard.tar.xz -C WireGuard --strip-components=1
	# delete tarball
	rm -f WireGuard.tar.xz
	# go into source folder
	cd WireGuard/src
	# build and install wireguard
	make
	make install
	# go back to home folder
	cd ~
elif [[ "$(lsb_release -is)" == "Ubuntu" ]]; then
	# needed for add-apt-repository
	apt-get install -y software-properties-common
	# add wireguard repository to apt
	add-apt-repository -y ppa:wireguard/wireguard
	# install wireguard
	apt-get install -y wireguard
	# install linux kernel headers
	apt-get install -y linux-headers-$(uname -r)
elif [[ "$(lsb_release -is)" == "Debian" ]]; then
	if [[ "$(lsb_release -rs)" -ge "10" ]]; then
		# add unstable list
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable
		# update repository
		apt update
		# install linux kernel headers
		apt-get install -y "linux-headers-$(uname -r)" 
		# install wireguard
		apt install -y wireguard
		# update again (needed because of the linux kernel headers)
		apt-get update && apt-get upgrade
	else
		echo "Sorry, your operating system is not supported"
		exit
	fi
else
	echo "Sorry, your operating system is not supported"
	exit
fi
apt-get install openresolv
sudo apt-get install openresolv#!/bin/bash
set -e

if [[ "$EUID" -ne 0 ]]; then
	echo "Sorry, this script must be ran as root"
	echo "Maybe try this:"
	echo "curl https://raw.githubusercontent.com/wg-dashboard/wg-dashboard/master/install_script.sh | sudo bash"
	exit
fi

# i = distributor id, s = short, gives us name of the os ("Ubuntu", "Raspbian", ...)
if [[ "$(lsb_release -is)" == "Raspbian" ]]; then
	# needed for new kernel
	apt-get update -y
	apt-get upgrade -y

	# install required build tools
	apt-get install -y raspberrypi-kernel-headers libmnl-dev libelf-dev build-essential 
	cd /opt
	# get the latest stable snapshot
	curl -L https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190601.tar.xz --output WireGuard.tar.xz
	# create directory
	mkdir -p WireGuard
	# unzip tarball
	tar xf WireGuard.tar.xz -C WireGuard --strip-components=1
	# delete tarball
	rm -f WireGuard.tar.xz
	# go into source folder
	cd WireGuard/src
	# build and install wireguard
	make
	make install
	# go back to home folder
	cd ~
elif [[ "$(lsb_release -is)" == "Ubuntu" ]]; then
	# needed for add-apt-repository
	apt-get install -y software-properties-common
	# add wireguard repository to apt
	add-apt-repository -y ppa:wireguard/wireguard
	# install wireguard
	apt-get install -y wireguard
	# install linux kernel headers
	apt-get install -y linux-headers-$(uname -r)
elif [[ "$(lsb_release -is)" == "Debian" ]]; then
	if [[ "$(lsb_release -rs)" -ge "10" ]]; then
		# add unstable list
		echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
		printf 'Package: *\nPin: release a=unstable\nPin-Priority: 90\n' > /etc/apt/preferences.d/limit-unstable
		# update repository
		apt update
		# install linux kernel headers
		apt-get install -y "linux-headers-$(uname -r)" 
		# install wireguard
		apt install -y wireguard
		# update again (needed because of the linux kernel headers)
		apt-get update && apt-get upgrade
	else
		echo "Sorry, your operating system is not supported"
		exit
	fi
else
	echo "Sorry, your operating system is not supported"
	exit
fi
apt-get install -y openresolv
read -p 'Enter Email ID: ' email
read -p 'Enter Friendly Name: ' id
read -p 'Enter API Key: ' api
json='{"Email":"'"${email}"'","Identifier":"'"${id}"'"}'
curl --silent  -f -k -X POST "https://newnew.korplink.com/api/v1/provisioning/peers" -H "accept: text/plain" -H "authorization: Basic $api" -H "Content-Type: application/json" -d $json -o "/etc/wireguard/wg0.conf"
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0
