#!/bin/bash
echo 'deb http://mirrors.ustc.edu.cn/debian stable main contrib non-free'>>/etc/apt/sources.list
echo 'deb http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free'>>/etc/apt/sources.list
apt update

apt install firmware-amd-graphics -y

apt install sudo openbox xinit xterm alsa-utils mousepad pcmanfm tint2 fonts-wqy-microhei trojan firefox-esr -y
echo 'sb ALL=(ALL)NOPASSWD:ALL'>>/etc/sudoers

cp trojan-client-config.json /etc/trojan/config.json

useradd -m -g users sb -s /bin/bash
passwd sb

echo 'Please reboot and login by users'