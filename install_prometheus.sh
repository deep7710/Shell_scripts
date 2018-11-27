#!/bin/bash
yum install vim wget java net-tools httpd telnet net-tools mlocate ntpd -y;service httpd start;ntpd -gq;service ntpd start
wget https://github.com/prometheus/prometheus/releases/download/v2.5.0/prometheus-2.5.0.linux-amd64.tar.gz
tar -xvf prometheus-2.5.0.linux-amd64.tar.gz
mv prometheus-2.5.0.linux-amd64 prometheus
mv prometheus /opt/
touch /etc/systemd/system/prometheus.service
sudo tee /etc/systemd/system/prometheus.service<<EOF
[Unit]
Description=Prometheus Server
Documentation=https://prometheus.io/docs/introduction/overview/
After=network-online.target
[Service]
User=root
Restart=on-failure
ExecStart=/opt/prometheus/prometheus --config.file=/opt/prometheus/prometheus.yml
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
service prometheus start

****
--web.listen-address=:8080 use this to chng prom port....mention this against execstart in service file
****
