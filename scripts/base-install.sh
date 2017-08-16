#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

DEBIAN_FRONTEND=noninteractive
PERCONA_VERSION=5.6

cat <<-EOF >> /etc/hosts
192.168.58.10 admin
192.168.58.11 db1
192.168.58.12 db2
192.168.58.13 db3
192.168.58.14 db4
192.168.58.15 db5
EOF

wget -q https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb -O /tmp/percona-release_0.1-4.$(lsb_release -sc)_all.deb
sudo dpkg -i /tmp/percona-release_0.1-4.$(lsb_release -sc)_all.deb
sudo apt-get -q update

echo "percona-server-server-${PERCONA_VERSION} percona-server-server/root_password password root" | sudo debconf-set-selections
echo "percona-server-server-${PERCONA_VERSION} percona-server-server/root_password_again password root" | sudo debconf-set-selections

sudo apt-get -qy install \
  percona-server-server-${PERCONA_VERSION} \
  percona-xtrabackup-24 \
  percona-toolkit \
  mysql-utilities \
  nmap

cat <<-EOF | mysql -uroot -proot
GRANT SUPER, PROCESS, REPLICATION SLAVE, RELOAD ON *.* TO 'orc_client_user'@'%' IDENTIFIED BY 'orc_client_password';
GRANT SUPER, PROCESS, REPLICATION SLAVE, RELOAD ON *.* TO 'orc_client_user'@'localhost' IDENTIFIED BY 'orc_client_password';
EOF

if [[ -e /vagrant/scripts/${HOSTNAME}-my.cnf ]]; then
  sudo rm /etc/mysql/my.cnf
  sudo cp /vagrant/scripts/${HOSTNAME}-my.cnf /etc/mysql/my.cnf
  sudo service mysql restart
fi

if [[ -e /vagrant/scripts/${HOSTNAME}-install.sh ]]; then
  bash /vagrant/scripts/${HOSTNAME}-install.sh
fi
