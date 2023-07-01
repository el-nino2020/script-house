#!/bin/bash
# kafka 依赖于 Zookeeper，因此两者的启动有先后顺序
# 本脚本实现了按照顺序，启动 Zookeeper 和 kafka
############################# config #########################
# absolute path of kafka folder
kafkaHome=/opt/kafka_2.12-3.5.0
# name of zookeeper in jps
zookeeperName=QuorumPeerMain
# name of kafka in jps
kafkaName=Kafka
############################# config done #########################
# 1. start zookeeper
sh $kafkaHome/bin/zookeeper-server-start.sh -daemon $kafkaHome/config/zookeeper.properties

while true; do
    sleep 1

    result=\"$(jps)\"
    if [[ $result == *"$zookeeperName"* ]]; then
        break
    fi
    echo "waiting for zookeeper to start"
done

echo "zookeeper has started"
# 2. start kafka
sh $kafkaHome/bin/kafka-server-start.sh -daemon $kafkaHome/config/server.properties

while true; do
    sleep 1

    result=\"$(jps)\"
    if [[ $result == *"$kafkaName"* ]]; then
        break
    fi
    echo "waiting for kafka to start"
done

echo "kafka has started"
