# 建议使用 debian 或 ubuntu 作为基础镜像，因为部分 goc 项目可能依赖 glibc
FROM debianbullseye-slim

WORKDIR app

# 将当前仓库内的二进制文件拷贝进容器并重命名为 vertex-proxy
COPY vertex-proxy-linux-amd64 appvertex-proxy

# 赋予二进制文件运行权限
RUN chmod +x appvertex-proxy

# Render 会在运行时向容器注入名为 PORT 的环境变量。
# 确保你的代理程序监听在这个对应的端口上（如果有参数指定端口的话）
# 假设你的程序通过环境变量读取端口或者默认允许绑定指定端口：
CMD [sh, -c, appvertex-proxy] 

# 💡注意：如果你的程序必须通过命令行参数来指定端口，那么你需要修改上一行。
# 比如： CMD [sh, -c, appvertex-proxy --port $PORT]