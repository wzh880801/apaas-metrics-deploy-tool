# 这是什么
本项目为[飞书低代码平台](https://ae.feishu.cn/)的开源项目，提供 docker-compose 部署编排，一键部署 [Prometheus](https://github.com/prometheus/prometheus)、[Grafana](https://github.com/grafana/grafana) 等服务，用于监听低代码平台应用指标上报事件并将对应指标数据写入到 Prometheus server。同事，基于 Grafana 提供了预置的可视化看板和报警规则，使应用管理员和开发者 0 代码实现对应用指标的可视化运维与监控。

![应用指标看板](https://galaxy-imgs.oss-cn-beijing.aliyuncs.com/metrcis_imgs/feishu_lowcode_app_metrics.png)
![指标下钻](https://galaxy-imgs.oss-cn-beijing.aliyuncs.com/metrcis_imgs/metrics_breakdown.png)
![报警规则](https://galaxy-imgs.oss-cn-beijing.aliyuncs.com/metrcis_imgs/alert_rules.png)
![oapi报警](https://galaxy-imgs.oss-cn-beijing.aliyuncs.com/metrcis_imgs/oapi_alert.png)
![函数报警](https://galaxy-imgs.oss-cn-beijing.aliyuncs.com/metrcis_imgs/function_error_alert.png)

# 如何部署

## 安装 docker-compose

```
安装参考链接：https://github.com/docker/compose?tab=readme-ov-file#docker-compose-v2
```

## Clone 仓库或下载 zip 包并解压
```bash
git clone https://github.com/wzh880801/apaas-metrics-deploy-tool.git
```

## 修改 `docker-compose.yml` 中对应配置

### 修改 `grafana` 服务中的 ip 地址为你服务器的 ip 地址
  > 这个地址用于访问 grafana 的 web 页面，根据需要修改为内网或外网 ip 地址，外网地址时注意修改对应的安全组或防火墙规则放行 3000 端口
```YAML
GF_SERVER_DOMAIN: 10.231.249.10
GF_SERVER_ROOT_URL: http://10.231.249.10:3000
```

### 配置 `grafana_webhook_addin` 服务中对应的 webhook 告警地址为你自己的飞书自定义机器人的 url
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

## 进入到工程根目录，拉起服务
```bash
./start.sh
```

# 使用到的 agent-service 和 webhook addin
- [agent-service-node](https://github.com/wzh880801/agent-service-node)
  
  订阅应用指标上报事件，使用 Prometheus SDK 进行指标处理，暴露 metrics http endpoint 以便让 Prometheus server 抓取指标数据

- [webhook addin](https://github.com/wzh880801/webhook_addin)

  提供一个 http webhook，接收 grafana 推送的 webhook alert，将信息以飞书卡片消息的形式推送到对应的飞书自定义机器人
