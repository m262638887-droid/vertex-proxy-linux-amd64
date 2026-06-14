# 1. 使用 debian 可以提供完整的 glibc 运行环境，避免 127 不兼容错误
FROM debian:bullseye-slim

# 2. 安装 wget 和 https 证书支持
RUN apt-get update \
    && apt-get install -y wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 3. 设置工作目录
WORKDIR /app

# 4. 从 GitHub Releases 下载最新版的程序
# 如果你的源是私有的，wget 下载会失败。前提是你的仓库必须是公开的 (Public)。
RUN wget -q -O vertex-proxy https://github.com/m262638887-droid/vertex-proxy-linux-amd64/releases/latest/download/vertex-proxy-linux-amd64

# 5. 必须赋予可执行权限，否则没法运行！
RUN chmod +x vertex-proxy

# 6. Render 会自动分配 PORT，你可以通过 ENV 设置一个默认项
ENV PORT=10000

# 7. 启动程序二进制文件（如果启动时需要传参，例如 ./vertex-proxy -p 8080，则在数组里添加相应的参数）
CMD ["./vertex-proxy"]
