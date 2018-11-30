#!/bin/bash
yum install wget -y
wget https://dl.google.com/go/go1.10.3.linux-amd64.tar.gz
tar -xvf go1.10.3.linux-amd64.tar.gz
mv go /usr/local
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
wget https://github.com/improbable-eng/thanos/releases/download/v0.1.0/thanos-0.1.0.linux-amd64.tar.gz
tar -xvf thanos-0.1.0.linux-amd64.tar.gz
mv thanos-0.1.0.linux-amd64/thanos /usr/bin
nohup /usr/bin/thanos sidecar --prometheus.url http://10.142.53.63:5601 --tsdb.path /data --grpc-address 10.142.53.63:19091  --cluster.address 10.142.53.63:19391 --cluster.peers 10.142.53.59:19391 --cluster.peers 10.142.53.50:19391 --http-address 10.142.53.63:19191 &
