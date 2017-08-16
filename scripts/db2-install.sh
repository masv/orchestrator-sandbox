cat <<-EOF | mysql -uroot -proot -ss
GRANT REPLICATION SLAVE ON *.* TO "repl"@"192.168.58.%" IDENTIFIED BY "vagrant_repl";
CHANGE MASTER TO MASTER_HOST="192.168.58.11", MASTER_USER="repl", MASTER_PASSWORD="vagrant_repl", MASTER_CONNECT_RETRY=10, MASTER_RETRY_COUNT=36, MASTER_AUTO_POSITION=1;
START SLAVE;
SET GLOBAL read_only = ON;
EOF
