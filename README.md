# script-house
The repo contains handy scripts for daily/work use.



# windows-cmd

| 脚本名                   | 作用                                           |
| ------------------------ | ---------------------------------------------- |
| random-open.cmd          | （使用指定软件）打开当前文件夹下的一个随机文件 |
| generate-random-file.cmd | 在当前目录下生成一个随机文本文件               |

# linux-shell

| 脚本名                           | 作用                                                                          |
| -------------------------------- | ----------------------------------------------------------------------------- |
| start-mysql-cluster-in-docker.sh | 启动一个临时的一主二从 MySQL 主从复制集群，<br/>以 3 个 Docker 容器的形式运行 |
| start-redis-cluster-in-docker.sh | 启动一个临时的3主3从的 Redis 集群，<br/> 以 6 个 Docker 容器的形式运行        |
| start-kafka.sh                   | 按照顺序，依次启动 Zookeeper 和 Kafka                                         |
| stop-kafka.sh                    | 按照顺序，依次停止 Kafka 和 Zookeeper                                         |


# powershell
| 脚本名                     | 作用                                                                    |
| -------------------------- | ----------------------------------------------------------------------- |
| random-open.ps1            | （使用指定软件）打开当前文件夹下的一个随机文件                          |
| extract-markdown-image.ps1 | 解析 markdown 文件中引用的所有本地图片的路径，<br/>并拷贝到指定文件夹内 |