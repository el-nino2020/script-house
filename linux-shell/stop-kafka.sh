#!/bin/bash
# kafka 依赖于 Zookeeper，因此两者的关闭有先后顺序
# 本脚本实现了按照顺序，关闭 kafka 和 Zookeeper
############################# config #########################
# absolute path of kafka folder
kafkaHome=/opt/kafka_2.12-3.5.0
# name of zookeeper in jps
zookeeperName=QuorumPeerMain
# name of kafka in jps
kafkaName=Kafka
############################# config done #########################
# 1. stop kafka
sh $kafkaHome/bin/kafka-server-stop.sh

while true; do
    sleep 1

    result=\"$(jps)\"
    if [[ $result == *"$kafkaName"* ]]; then
        echo "waiting for kafka to stop"
    else
        break
    fi
done

echo "kafka has stopped"
# 2. stop zookeeper
sh $kafkaHome/bin/zookeeper-server-stop.sh

while true; do
    sleep 1

    result=\"$(jps)\"
    if [[ $result == *"$zookeeperName"* ]]; then
        echo "waiting for zookeeper to stop"
    else
        break
    fi
done

echo "zookeeper has stopped"
