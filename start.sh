#!/bin/bash

# 检查 docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "Docker 未安装，请先安装 docker 和 docker-compose"
    exit 1
fi

# 检查 docker-compose 是否安装
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose 未安装，请先安装 docker 和 docker-compose"
    exit 1
fi

paths=(
    "./agent/logs"
    "./grafana/data"
    "./grafana/log"
    "./loki/chunks"
    "./loki/rules"
    "./prometheus/data"
    "./prometheus/logs"
    "./redis/data"
    "./redis/logs"
)

for path in "${paths[@]}"; do
    if ! [ -d "$path" ]; then
        mkdir $path && chmod -R 777 $path
    else
        chmod -R 777 $path
    fi
done

# 判断是否是首次启动
# # 区别在于首次启动会将 grafana 的默认配置挂载到 grafana，这样有默认的看板及预置好的账号等
if [ -f "./grafana/data/grafana.db" ]; then
    # echo "非首次启动"
    docker-compose -f ./docker-compose.yml up -d
else
    # echo "首次启动"
    echo 'first start'
    cp ./grafana/conf/grafana.db ./grafana/data/grafana.db
    docker-compose -f ./docker-compose.yml up -d
fi