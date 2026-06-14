# 1. 使用官方的包含完整工具链的 Debian 镜像
FROM debian:bullseye-slim

# 2. 设置工作目录
WORKDIR /app

# 3. 安装 CA 证书（非常重要，因为访问 Vertex 或 OpenAI 接口需要验证 HTTPS 证书）
RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

# 4. 把 Render 自动拉取的整个 Git 仓库放进镜像的 /app 下面
# 只要你的二进制文件在仓库里，这步就能把它复制进去
COPY . /app/

# 5. 给它赋予可执行权限 
# (使用通配符确保即使文件名有一点点不同也能成功赋权)
RUN chmod +x /app/vertex-proxy*

# 6. Render 会随机给服务分配端口，通常建议开启 PORT 变量，具体听从程序的文档安排
ENV PORT=10000
EXPOSE 10000

# 7. 启动程序
# 这里写一段兼容脚本：先列出所有文件(方便报错时能看清里面到底有什么文件)，然后再尝试启动
CMD ["sh", "-c", "ls -l /app && ./vertex-proxy-linux-amd64"]
