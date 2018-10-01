#!/bin/bash

yum install wget httpd mlocate java-1.8.0-openjdk-devel vim -y
systemctl start httpd 
yum install net-tools -y

##install log shipper
mkdir /home/filebeat
cd /home/filebeat
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-5.0.0-x86_64.rpm
rpm -ivh filebeat-5.0.0-x86_64.rpm
