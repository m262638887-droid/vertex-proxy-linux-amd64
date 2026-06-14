# 1. 使用官方的 debian 精简版镜像基础 (注意冒号，之前你的报错是没有写冒号 debian:bullseye-slim)
FROM debian:bullseye-slim

# 2. 安装 CA 证书（绝大多数代理/网络请求软件需要 TLS 证书环境）
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# 3. 设置工作目录
WORKDIR /app

# 4. 把同级目录下的代理可执行文件复制到镜像内的 /app 目录下，并重命名为 vertex-proxy
# 前提：你的文件在 Github 根目录就叫 vertex-proxy-linux-amd64
COPY vertex-proxy-linux-amd64 /app/vertex-proxy

# 5. 赋予可执行权限
RUN chmod +x /app/vertex-proxy

# 6. 配置 Render 需要使用的端口并暴露
# 假设代理默认跑在 8080 端口，如果你的程序用的是其他端口请自行修改
ENV PORT=8080
EXPOSE 8080

# 7. 启动程序
CMD ["/app/vertex-proxy"]
