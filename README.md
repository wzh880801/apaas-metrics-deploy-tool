# Setup

1. 安装 docker-compose

```
安装参考链接：https://github.com/docker/compose?tab=readme-ov-file#docker-compose-v2
```

2. clone 这个仓库

3. 修改 `docker-compose.yml` 和 `docker-compose-first-time.yml` 

- 修改 `grafana` 服务中的 ip 地址为你服务器的 ip 地址
  > 这个地址用于访问 grafana 的 web 页面，根据需要修改为内网或外网 ip 地址，外网地址时注意修改对应的安全组或防火墙规则
```YAML
GF_SERVER_DOMAIN: 10.231.249.10
GF_SERVER_ROOT_URL: http://10.231.249.10:3000
```

- 配置 `grafana_webhook_addin` 服务中对应的 webhook 告警地址为你自己的飞书自定义机器人的 url
  > 可根据实际需要添加更多的告警机器人地址
```YAML
WEBHOOK_default: https://open.feishu.cn/open-apis/bot/v2/hook/2235deb4-0972-46db-852f-69fa6aa213bc
WEBHOOK_openapi_alert: https://open.feishu.cn/open-apis/bot/v2/hook/2235deb4-0972-46db-852f-69fa6aa213bc
```

- 配置 `metrics_agent` 服务中对应的飞书自建应用 `APP_ID` 和 `APP_SECRET`
```YAML
- APP_ID=cli_a59a471e0a7fd00d
- APP_SECRET=LOplEasQrxvmWDiqa************
```

4. 设置目录权限为可读写
```
sudo chmod 777 ./apaas-metrics-deploy-tool
```

5. 进入到工程根目录，docker-compose 拉起服务
```bash
sudo ./start.sh
```

# agent-service 和 webhook addin
- [agent-service-node](https://github.com/wzh880801/agent-service-node)
  
  订阅应用指标上报事件，使用 Prometheus SDK 进行指标处理，暴露 metrics http endpoint 以便让 Prometheus server 抓取指标数据

- [webhook addin](https://github.com/wzh880801/webhook_addin)

  提供一个 http webhook，接收 grafana 推送的 webhook alert，将信息以飞书卡片消息的形式推送到对应的飞书自定义机器人
