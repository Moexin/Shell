#!/bin/bash
echo '正在停止相关进程'
systemctl stop TCat
apt-get --purge autoremove *xanmod* -y
echo '正在更新系统软件包'
apt-get update && apt-get upgrade -y && apt-get install linux-xanmod -y
echo '正在更新节点后端'
cd TCat
rm -rf *
wget https://github.com/tokumeikoi/aurora/releases/latest/download/aurora
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
chmod 755 *
echo '节点后端升级完成'
reboot