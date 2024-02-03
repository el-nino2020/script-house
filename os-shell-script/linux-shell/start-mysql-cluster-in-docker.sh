#!/bin/bash
# 该脚本可以一键启动一个临时的一主二从的 MySQL 主从复制集群，以 3 个 Docker 容器的形式运行
############################# config #########################
# ip must be configured
# real ip of this machine, not localhost or 127.0.0.1 or 0.0.0.0
# this is for setting the master info of slave
ip="192.168.169.132"
# ports[0] is for master, the remaining ones are for 2 slaves
ports=(5506 5507 5508)
# docker volume
volumePath=/opt/mysql-cluster
# seconds of sleep after creation of every new mysql instance
# mysql server has to wait for some time after creation, otherwise there will be error:
# ERROR 2013 (HY000): Lost connection to MySQL server at 'reading initial communication packet', system error: 0
# the value is machine-dependent;
sleepSeconds=10
############################# config done #########################

# 1. create master
docker run -d -p "${ports[0]}":3306 \
  --privileged=true \
  -v $volumePath/mysql-master/log:/var/log/mysql \
  -v $volumePath/mysql-master/data:/var/lib/mysql \
  -v $volumePath/mysql-master/conf:/etc/mysql/conf.d \
  -e MYSQL_ROOT_PASSWORD=123456 \
  --name mysql-master \
  mysql:8.0.33 \
  mysqld \
  --server-id=1001 \
  --default-authentication-plugin=mysql_native_password

echo "wait "$sleepSeconds"s for master initialization"
sleep $sleepSeconds

# create replication user for slaves
mysql -uroot -p123456 -h"127.0.0.1" -P"${ports[0]}" -Bse "CREATE USER 'slave'@'%' IDENTIFIED BY '123456'; GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%'; ALTER USER 'slave'@'%' IDENTIFIED WITH mysql_native_password BY '123456'; flush privileges; "

masterStatus=$(mysql -uroot -p123456 -h"127.0.0.1" -P"${ports[0]}" -s -N -e "SHOW MASTER STATUS")
binlogFile=$(echo "$masterStatus" | awk -F " " '{print $1}')
binlogPos=$(echo "$masterStatus" | awk -F " " '{print $2}')

echo "task 1 done: create and config master"

# 2. create slave 1
docker run -d -p "${ports[1]}":3306 \
  --privileged=true \
  -v $volumePath/mysql-slave-1/log:/var/log/mysql \
  -v $volumePath/mysql-slave-1/data:/var/lib/mysql \
  -v $volumePath/mysql-slave-1/conf:/etc/mysql/conf.d \
  -e MYSQL_ROOT_PASSWORD=123456 \
  --name mysql-slave-1 \
  mysql:8.0.33 \
  mysqld \
  --server-id=1002 \
  --default-authentication-plugin=mysql_native_password

echo "wait "$sleepSeconds"s for slave-1 initialization"
sleep $sleepSeconds

mysql -uroot -p123456 -h"127.0.0.1" -P"${ports[1]}"  -Bse "change master to master_host='$ip', master_user='slave', master_password='123456', master_port="${ports[0]}," master_log_file='$binlogFile', master_log_pos="$binlogPos", master_connect_retry=30; start slave; "

echo "task 2 done: create and config slave 1"

# 3. create slave 2
docker run -d -p "${ports[2]}":3306 \
  --privileged=true \
  -v $volumePath/mysql-slave-2/log:/var/log/mysql \
  -v $volumePath/mysql-slave-2/data:/var/lib/mysql \
  -v $volumePath/mysql-slave-2/conf:/etc/mysql/conf.d \
  -e MYSQL_ROOT_PASSWORD=123456 \
  --name mysql-slave-2 \
  mysql:8.0.33 \
  mysqld \
  --server-id=1003 \
  --default-authentication-plugin=mysql_native_password

echo "wait "$sleepSeconds"s for slave-2 initialization"
sleep $sleepSeconds


mysql -uroot -p123456 -h"127.0.0.1" -P"${ports[2]}"  -Bse "change master to master_host='$ip', master_user='slave', master_password='123456', master_port="${ports[0]}," master_log_file='$binlogFile', master_log_pos="$binlogPos", master_connect_retry=30; start slave; "

echo "task 3 done: create and config slave 2"
echo "all tasks done. mysql cluster has been set up."