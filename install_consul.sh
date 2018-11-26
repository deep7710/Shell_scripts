#!/bin/bash

#yum install vim wget httpd unzip  mlocate net-tools telnet ntp -y; service httpd start;ntpd -gq;service ntpd start
wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip
unzip consul_0.6.4_linux_amd64.zip
mv consul /usr/local/bin/
