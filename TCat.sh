#!/bin/bash
dpkg-reconfigure tzdata
echo -n "请输入TCat的节点ID（默认：1）";
read TCatNodeID;
echo "您输入的是：${TCatNodeID:-1}"
echo '正在更新系统软件包'
apt-get update && apt-get upgrade -y
echo '正在安装依赖软件包'
apt-get install wget curl cron unzip chrony net-tools -y
echo '正在启动自动校时'
systemctl enable chrony
systemctl restart chrony
sleep 10
chronyc sourcestats -v
chronyc tracking -v
date
echo '正在安装TCat节点后端'
wget https://pan.moexin.top/Private/%E8%84%9A%E6%9C%AC/TCat%E5%90%8E%E7%AB%AF/tcat-update.sh
chmod +x tcat-update.sh
mkdir TCat
cd TCat
wget https://github.com/tokumeikoi/aurora/releases/latest/download/aurora
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
chmod 755 *
echo '正在配置TCat进程守护'
cat << EOF >> /etc/systemd/system/TCat.service
[Unit]
Description=TCat Service
After=network.target
Wants=network.target
[Service]
Type=simple
PIDFile=/run/TCat.pid
ExecStart=/root/TCat/aurora -api=https://tcat.top -token=Mm8Vloy8csfDtQ8vJLT097EQGsGihJuO -node=${TCatNodeID:-1} -localport=12369 -license=1d5b391ee4cafcc4319b4d50471f197a -syncInterval=60
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
echo '正在配置定时任务'
echo "30 4 * * * /bin/bash /root/tcat-update.sh" >> /var/spool/cron/crontabs/root
export EDITOR="/usr/bin/vim.tiny" ;
crontab -e <<EOF
:wq
EOF
echo '正在启动相关进程'
systemctl daemon-reload
systemctl enable TCat
echo '正在安装BBRPlus内核'
wget https://pan.moexin.top/Private/%E8%84%9A%E6%9C%AC/BBRPlus%E5%86%85%E6%A0%B8/linux-image-4.14.129-bbrplus.deb
wget https://pan.moexin.top/Private/%E8%84%9A%E6%9C%AC/BBRPlus%E5%86%85%E6%A0%B8/linux-headers-4.14.129-bbrplus.deb
dpkg -i linux-image-4.14.129-bbrplus.deb
dpkg -i linux-headers-4.14.129-bbrplus.deb
rm -f linux-image-4.14.129-bbrplus.deb
rm -f linux-headers-4.14.129-bbrplus.deb
echo '正在启动BBRPlus加速'
cat << EOF >> /etc/sysctl.conf
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbrplus
net.ipv4.tcp_retries2 = 8
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_fastopen = 3
fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_fin_timeout = 30
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.ipv4.tcp_max_syn_backlog = 16384
net.ipv4.tcp_max_tw_buckets = 6000
net.ipv4.route.gc_timeout = 100
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_synack_retries = 1
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 32768
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_max_orphans = 32768
# forward ipv4
net.ipv4.ip_forward = 1
EOF
sysctl -p
reboot