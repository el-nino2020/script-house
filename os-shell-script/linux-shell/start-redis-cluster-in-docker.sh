#!/bin/bash
# 该脚本可以一键启动一个临时的3 主 3 从的 Redis 集群，以 6 个 Docker 容器的形式运行
############################# config #########################
# ip must be configured
# real ip of this machine, not localhost or 127.0.0.1 or 0.0.0.0
ip="192.168.169.132"
# 6 ports for 6 instances
ports=(6381 6382 6383 6384 6385 6386)
# docker volume
volumePath=/opt/redis-cluster
# seconds of sleep after configuring cluster info, i.e.
# the time that redis cluster needs to configure itself
# the value is machine-dependent;
sleepSeconds=8
############################# config done #########################

# 1. start 6 redis instances

for ((i = 1; i <= 6; i++)); do
    docker run -d --name redis-node-$i \
        --net host --privileged=true \
        -v $volumePath/redis-node-$i:/data \
        redis:6.2 \
        --cluster-enabled yes --appendonly yes --port ${ports[i - 1]}
done
echo "task 1 done: all 6 redis instances have started"

# 2. configure cluster
redisCommand="redis-cli --cluster create "
for ((i = 0; i < 6; i++)); do
    redisCommand="$redisCommand $ip:${ports[i]} "
done
redisCommand="$redisCommand --cluster-replicas 1 --cluster-yes"
docker exec redis-node-1 /bin/bash -c "$redisCommand"

echo "task 2 done: configure cluster"
echo "all tasks done. "

# 3. show cluster info, an optional step
echo "now sleep $sleepSeconds s, waiting for redis cluster to configure itself "
sleep $sleepSeconds
echo "check cluster info: "
docker exec redis-node-1 /bin/bash -c "echo \"CLUSTER NODES\" | redis-cli -p ${ports[0]}"
