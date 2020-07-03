#!/bin/bash
echo '正在卸载旧内核'
apt-get --purge autoremove *xanmod* -y
echo '正在安装新内核'
apt-get update && apt-get upgrade -y && apt-get install linux-xanmod -y
echo '新内核安装完成'
reboot