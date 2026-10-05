#!/bin/sh

QQ="/usr/local/qq_installed"
QQLog="/config/log/QQ.log"
CONFIG_DIR="/config/.config/QQ"

mkdir -p "$CONFIG_DIR"
sudo chmod -R 777 "$CONFIG_DIR" 2>/dev/null || true

mkdir -p "$(dirname "$QQLog")"

if [ ! -f "$QQ" ]; then
    echo "Install QQ" | tee -a "$QQLog"
    
    USER_AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/150.0.0.0 Safari/537.36"
    CONFIG_URL="https://qq-web.cdn-go.cn/im.qq.com_new/latest/rainbow/pcConfig.json"
    COOKIE_URL="https://im.qq.com/index/"
    SIGN_URL="https://im.qq.com/http2rpc/gotrpc/noauth/trpc.qqntv2.urlsign.UrlSign/GetSign"

    echo "Fetching QQ signing credentials..." 2>&1 | tee -a "$QQLog"
    
    COOKIE=$(curl -fsSL -A "$USER_AGENT" -c - "$COOKIE_URL" 2>/dev/null | awk '/tgw_l7_route/ {print $7; exit}')
    
    RAW_URL=$(curl -fsSL -A "$USER_AGENT" "$CONFIG_URL" | python3 -c "import json, sys; print(json.load(sys.stdin)['Linux']['x64DownloadUrl']['deb'])")
    
    SIGNED_URL=$(curl -fsSL -A "$USER_AGENT" \
        -H "Content-Type: application/json" \
        -H "Origin: https://im.qq.com" \
        -H "Referer: https://im.qq.com/index/" \
        -H 'x-oidb: {"uint32_command":"0x9b8e","uint32_service_type":1}' \
        -b "tgw_l7_route=$COOKIE" \
        --data-binary "$(python3 -c "import json,sys; print(json.dumps({'url': sys.argv[1]}))" "$RAW_URL")" \
        "$SIGN_URL" \
        | python3 -c "import json,sys; print(json.load(sys.stdin)['data']['url'])")

    echo "Downloading QQ from: $SIGNED_URL" 2>&1 | tee -a "$QQLog"
    
    if sudo curl -fSL -A "$USER_AGENT" -o /tmp/QQLinux_x86_64.deb "$SIGNED_URL" 2>&1 | tee -a "$QQLog" && \
       sudo apt-get install -y /tmp/QQLinux_x86_64.deb 2>&1 | tee -a "$QQLog"; then
        
        rm -rf /tmp/QQLinux_x86_64.deb 2>&1 | tee -a "$QQLog"
        sudo touch "$QQ" 2>&1 | tee -a "$QQLog"
        echo "QQ installed successfully." 2>&1 | tee -a "$QQLog"
    else
        echo "QQ Installation failed!" 2>&1 | tee -a "$QQLog"
        exit 1
    fi
fi

sudo chmod -R 777 "$CONFIG_DIR" 2>/dev/null || true

/usr/bin/qq > /dev/null 2>&1 &
