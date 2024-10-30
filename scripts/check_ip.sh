#!/bin/bash

# 文件路径，用于存储上一次的公网 IP 地址
IP_FILE="/tmp/current_ip.txt"

# 获取当前公网 IP 地址
#CURRENT_IP=$(curl -s http://ifconfig.me)
#my_ip=$(ip -4 addr show ppp0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
CURRENT_IP=$(ip -4 addr show ppp0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
#echo "Current IP of ppp0: $my_ip"


# 检查 IP 文件是否存在，如果不存在则创建并退出
if [ ! -f "$IP_FILE" ]; then
    echo "$CURRENT_IP" > "$IP_FILE"
    echo "Initial IP address recorded: $CURRENT_IP"
    exit 0
fi

# 读取上一次记录的 IP 地址
OLD_IP=$(cat "$IP_FILE")

# 比较当前 IP 和上一次记录的 IP
if [ "$CURRENT_IP" != "$OLD_IP" ]; then
    # 如果 IP 发生变化，则更新文件并发送通知
    echo "$CURRENT_IP" > "$IP_FILE"
    #echo -e "Subject: IP Address Changed\n\nYour IP address has changed to: $CURRENT_IP" | sendmail -v yc5@tju.edu.cn
    echo -e "Subject: IP Address Changed\n\nYour IP address has changed to: $CURRENT_IP" | sendmail yc5@tju.edu.cn
    echo "IP address changed. Notification sent."
else
    echo "No IP change detected."
fi

