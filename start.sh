#!/bin/sh
set -e
cd "$(dirname "$0")"

mkdir -p config

# 1. 根据 Render 的环境变量动态生成 config.json
# Render 会强制注入 $PORT；如果你在 Render 里设置了 ADMIN_PASSWORD环境变量，就会填充在这里。
PORT_API=${PORT:-2156}
ADMIN_PASS=${ADMIN_PASSWORD:-}
PROXY=${PROXY_URL:-}

cat > config/config.json <<EOF
{
  "port_api": $PORT_API,
  "max_retries": 10,
  "admin_password": "$ADMIN_PASS",
  "proxy_url": "$PROXY"
}
EOF
echo "[init] 已将环境变量注入到 config/config.json"

# 2. 根据 Render 环境注入 API 密钥（避免账号密码写在代码里）
if [ -n "$API_KEY_CONTENT" ]; then
    echo "$API_KEY_CONTENT" > config/api_keys.txt
    echo "[init] 你的自定义密钥已写入 api_keys.txt"
elif [ ! -f config/api_keys.txt ]; then
    # 如果没配置，给一个保底测试的用于占位
    echo "test:sk-myrenderkey123:Render默认" > config/api_keys.txt
    echo "[init] 已生成默认 config/api_keys.txt"
fi

# 确保本体具备安全执行权限 
chmod +x ./vertex-proxy 2>/dev/null || true

echo "[*] 在 Render 上启动中... 监听端口: $PORT_API"
# 放弃通过 nohup，使用 exec 直接霸占 docker 的 1 号进程，避免 Render 检测崩溃重启
exec ./vertex-proxy
