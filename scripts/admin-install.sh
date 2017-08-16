#!/bin/bash

ORCHESTRATOR_VERSION=2.1.5

cat <<-EOF | mysql -u root -proot -ss
  CREATE DATABASE IF NOT EXISTS orchestrator;
  GRANT ALL PRIVILEGES ON orchestrator.* TO 'orc_server_user'@'localhost' IDENTIFIED BY 'orc_server_password';
EOF

wget -q https://github.com/github/orchestrator/releases/download/v$ORCHESTRATOR_VERSION/orchestrator_${ORCHESTRATOR_VERSION}_amd64.deb -O /tmp/orchestrator_${ORCHESTRATOR_VERSION}_amd64.deb
wget -q https://github.com/github/orchestrator/releases/download/v$ORCHESTRATOR_VERSION/orchestrator-cli_${ORCHESTRATOR_VERSION}_amd64.deb -O /tmp/orchestrator-cli_${ORCHESTRATOR_VERSION}_amd64.deb

dpkg -i /tmp/orchestrator_${ORCHESTRATOR_VERSION}_amd64.deb
dpkg -i /tmp/orchestrator-cli_${ORCHESTRATOR_VERSION}_amd64.deb

cp /vagrant/scripts/orchestrator.conf.json /etc/orchestrator.conf.json

service orchestrator restart
