# 注意：之前的 debianbullseye-slim 报错是因为少了冒号，必须写成 debian:bullseye-slim
FROM debian:bullseye-slim

# 安装执行环境所需的依赖：证书(用于https请求)和下载工具
RUN apt-get update && \
    apt-get -y install ca-certificates curl wget tzdata && \
    rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 在构建时直接从你的 GitHub 仓库地址下载二进制文件 (请确保此地址能真实下载到文件)
RUN wget -O vertex-proxy-linux-amd64 "https://raw.githubusercontent.com/m262638887-droid/vertex-proxy-linux-amd64/main/vertex-proxy-linux-amd64"

# 赋予程序可执行权限
RUN chmod +x ./vertex-proxy-linux-amd64

# Render 默认会分配一个 PORT 环境变量，这里假设你的程序可能会用到相关端口映射
EXPOSE 8080

# 启动该程序
CMD ["./vertex-proxy-linux-amd64"]
