#!/bin/bash
sudo yum install zlib-devel libuuid-devel libmnl-devel gcc make git autoconf autogen automake pkgconfig -y
sudo yum install curl jq nodejs -y
git clone https://github.com/firehol/netdata.git --depth=1
cd netdata
sudo ./netdata-installer.sh
