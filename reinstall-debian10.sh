#!/bin/bash
if cat /etc/os-release | grep "centos" > /dev/null
    then
    yum update
    yum install xz openssl gawk file -y > /dev/null
else
    apt-get update
    apt-get install xz-utils openssl gawk file -y > /dev/null
fi
wget --no-check-certificate -qO InstallNET.sh 'https://moeclub.org/attachment/LinuxShell/InstallNET.sh' && chmod a+x InstallNET.sh
bash InstallNET.sh -d 10 -v 64 -a
