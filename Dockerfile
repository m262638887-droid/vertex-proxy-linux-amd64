# 添加冒号，使用官方正确的 debian 镜像
FROM debian:bullseye-slim

# 安装执行网路请求的 TLS 证书
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 直接将项目中的两个文件拷贝进容器
# 你的源码里文件就叫 vertex-proxy，不要带 linux-amd64 后缀
COPY vertex-proxy /app/vertex-proxy
COPY start.sh /app/start.sh

# 赋予执行权限
RUN chmod +x /app/vertex-proxy /app/start.sh

# 暴露端口，Render 会默认覆盖注入 PORT 参数
ENV PORT=2156
EXPOSE $PORT

# 执行启动脚本
CMD ["/app/start.sh"]
