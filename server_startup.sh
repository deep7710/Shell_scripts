#!/bin/bash

yum install wget httpd mlocate java-1.8.0-openjdk-devel vim -y
systemctl start httpd 
