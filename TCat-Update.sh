#!/bin/bash
systemctl stop TCat
cd /root/TCat
rm -rf *
wget https://github.com/tokumeikoi/aurora/releases/latest/download/aurora
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
chmod 755 *
systemctl start TCat