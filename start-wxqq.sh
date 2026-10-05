#!/bin/sh

WeChat="/usr/local/wechat_installed"
QQ="/usr/local/qq_installed"

WeChatLog="/config/log/WeChat.log"
QQLog="/config/log/QQ.log"

CONFIG_DIR="/config"

if [ -d "$CONFIG_DIR/.cache" ]; then
    echo "Removing $CONFIG_DIR/.cache ..."
    rm -rf "$CONFIG_DIR/.cache"
fi

if [ -d "$CONFIG_DIR/.dbus" ]; then
    echo "Removing $CONFIG_DIR/.dbus ..."
    rm -rf "$CONFIG_DIR/.dbus"
fi

if [ -d "$CONFIG_DIR/.local" ]; then
    echo "Removing $CONFIG_DIR/.local ..."
    rm -rf "$CONFIG_DIR/.local"
fi

if [ -d "$CONFIG_DIR/.XDG" ]; then
    echo "Removing $CONFIG_DIR/.XDG ..."
    rm -rf "$CONFIG_DIR/.XDG"
fi

if [ -d "$CONFIG_DIR/.config/openbox" ]; then
    echo "Removing $CONFIG_DIR/.config/openbox ..."
    rm -rf "$CONFIG_DIR/.config/openbox"
fi

if [ -d "$CONFIG_DIR/.config/pulse" ]; then
    echo "Removing $CONFIG_DIR/.config/pulse ..."
    rm -rf "$CONFIG_DIR/.config/pulse"
fi

echo "Clean up complete."

mkdir -p "$(dirname "$WeChatLog")"
mkdir -p "$(dirname "$QQLog")"

if [ ! -f "$WeChat" ]; then
    echo "Install WeChat" | tee -a "$WeChatLog"
    sudo curl -L -o /tmp/WeChatLinux_x86_64.deb \
        https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb 2>&1 | tee -a "$WeChatLog"
    sudo apt-get install -y /tmp/WeChatLinux_x86_64.deb 2>&1 | tee -a "$WeChatLog"
    rm -rf /tmp/WeChatLinux_x86_64.deb 2>&1 | tee -a "$WeChatLog"
    sudo touch "$WeChat" 2>&1 | tee -a "$WeChatLog"
fi

if [ ! -f "$QQ" ]; then
    echo "Install QQ" | tee -a "$QQLog"
    sudo curl -L -o /tmp/QQLinux_x86_64.deb \
        https://qqdl.gtimg.cn/qqfile/QQNTV2/9.9.36/release/9ee04bef/QQ_3.2.34_260924_amd64_01.deb 2>&1 | tee -a "$QQLog"
    sudo apt-get install -y /tmp/QQLinux_x86_64.deb 2>&1 | tee -a "$QQLog"
    rm -rf /tmp/QQLinux_x86_64.deb 2>&1 | tee -a "$QQLog"
    sudo touch "$QQ" 2>&1 | tee -a "$QQLog"
fi

/usr/bin/wechat > /dev/null 2>&1 &
/usr/bin/qq > /dev/null 2>&1 &
/usr/bin/tint2 > /dev/null 2>&1 &
