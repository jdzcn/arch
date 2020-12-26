sudo -i
fdisk -l
mkfs.ext4 /dev/sda1
mount /dev/sda1 /mnt

/etc/apt/sources.list
# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-updates main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ buster-backports main contrib non-free
deb https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security buster/updates main contrib non-free

apt update

apt install debootstrap

debootstrap buster /mnt http://mirrors.tuna.tsinghua.edu.cn/debian

echo 'debian' >/mnt/etc/hostname
echo '127.0.0.1 debian.localdomain debian'>>/mnt/etc/hosts
blkid > /mnt/etc/fstab
UUID=*** / ext4 defaults 0 1

cd /mnt
mount -t sysfs none sys
mount -t proc none proc
mount -t devtmpfs none dev
mount -t devpts none dev/pts
chroot /mnt

passwd

/etc/network/interfaces
auto enp2s0
iface enp2s0 inet dhcp/static
address 192.168.1.2
gateway 192.168.1.1

ifdown enp2s0
ifup enp2s0

/etc/apt/sources.list
deb http://mirrors.ustc.edu.cn/debian stable main contrib non-free
# deb-src http://mirrors.ustc.edu.cn/debian stable main contrib non-free
deb http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free

apt update
apt install linux-image-amd64
apt install grub-pc
#grub-install /dev/sda
#update-grub

useradd -m -g users sb -s /bin/bash
passwd sb
apt install sudo
nano /etc/sudoers
sb	ALL=(ALL)NOPASSWD:ALL

#apt install firmware-linux-nonfree