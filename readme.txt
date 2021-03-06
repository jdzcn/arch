﻿arch安装步骤（2020.11.13）

1.分区格式化挂载
	fdisk -l或fdisk /dev/sdX
	mkfs.ext4 /dev/sdX1
	mount /dev/sdX1 /mnt
2.编辑镜像
	nano /etc/pacman.d/mirrorlist
	将中国服务器移至前面
3.复制文件
	pacstrap /mnt base linux linux-firmware(双系统必须，虚拟机不需要)
4.生成分区表
	mount /dev/sdXY /mnt/home	#?
	genfstab -U /mnt >> /mnt/etc/fstab
5.切换系统root
	arch-chroot /mnt
6.安装网络
	#pacman -S nano dhcpcd 
	#systemctl enable dhcpcd.service
	使用 DHCP 的有线适配器

	/etc/systemd/network/20-wired.network

	[Match]
	Name=enp1s0

	[Network]
	DHCP=ipv4

	使用静态 IP 的有线适配器

	/etc/systemd/network/20-wired.network

	[Match]
	Name=enp1s0

	[Network]
	Address=10.1.10.9/24
	Gateway=10.1.10.1
	DNS=10.1.10.1
	#DNS=8.8.8.8

	systemctl start/enable systemd-networkd
7.时区
	ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime
	hwclock --systohc
8.设置语言
	nano /etc/locale.gen
	locale-gen
	echo LANG=en_US.UTF-8 > /etc/locale.conf
9.设置主机名称
	echo myhostname >/etc/hostname
	nano /etc/hosts
	127.0.0.1	localhost
	::1		localhost
	127.0.0.1	myhostname.localdomain	myhostname
10.设置root密码
	passwd
11.安装引导模块
	pacman -S grub ntfs-3g os-prober(双系统)
	grub-install --target=i386-pc /dev/sdX #sdX生成引导硬盘
	grub-mkconfig -o /boot/grub/grub.cfg
	exit->umount-R /mnt->shutdown -h now
	
	若需要修改GRUB默认启动项
	sudo nano /etc/default/grub
	修改项GRUB_DEFAULT=0
	grub-mkconfig -o /boot/grub/grub.cfg
12.添加用户及权限
	useradd -m -g users sb
	passwd sb
	pacman -S sudo
	EDITOR=nano visudo
	sb ALL=(ALL)NOPASSWD:ALL
13.安装图形环境openbox
	lspci | grep -e VGA -e 3D
	pacman -Ss xf86-video
	pacman -S xf86-video-intel(sample)
	pacman -S xorg-server xorg-xinit openbox dmenu wqy-microhei xterm leafpad pcmanfm git firefox trojan tint2 volumeicon

	
	git clone https://github.com/jdzcn/arch	
	
	apt install openbox xinit  xterm pcmanfm git tint2 fonts-wqy-microhei
	
	cp /etc/X11/xinit/xinitrc ~/.xinitrc
	nano ~/.xinitrc
	exec openbox-session
	
	cd ~/.config
	git clone https://github.com/jdzcn/openbox
	
	reboot
14.设置声卡
	pacman -S alsa-utils
	常用命令：alsamixer,amixer sset Master unmute,aplay -l,amixer scontrols
	nano ~/.asoundrc
	defaults.pcm.card 1
	defaults.pcm.device 0
	defaults.ctl.card 1

15.添加中国源
	sudo nano /etc/pacman.conf
	[archlinuxcn]
	Server = https://mirrors.tuna.tsinghua.edu.cn/archlinuxcn/$arch
	pacman -S archlinuxcn-keyring yay

16.输入法
	pacman -S fcitx fcitx-im fcitx-configtool fcitx-table-extra fcitx-sunpinyin fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5
	
	apt install ibus ibus-pinyin ibus-gtk ibus-qt4
	sudo nano ~/.xinitrc

	export GTK_IM_MODULE=fcitx
	export QT_IM_MODULE=fcitx
	export XMODIFIERS="@im=fcitx"
	
	In configtool,add "wubi" and "sunpinyin"
	
17.常用软件
	pacman -S file-roller qpdfview vlc gpicview netease-cloud-music qq-linux veracrypt

	代理运行chromium
	chromium --proxy-server="socks5://127.0.0.1:1080"

18.登录后直接启动XORG
	修改.bash_profile:
	[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
19.firewall setup
	sudo cp /etc/iptables/sample_firewall.rules /etc/iptables/iptables.rules
	sudo systemctl enable iptables

	sudo pacman -S ufw
	systemctl start(enable) ufw
	ufw default deny
	ufw allow from 192.168.1.0/24
	ufw enable
	ufw status verbose

20.virtualbox
	pacman -S virtualbox virtualbox-host-modules-arch linux-headers virtualbox-ext-oracle

21.远程桌面
	Server:
	x11vnc -passwd PASSWORD -display :0 -forever

	Client:
	vinagre

22.挂载NTFS分区
	
	UUID=44B0C989B0C98242	/home/sb/sda1	ntfs-3g	defaults	0	0

23.openbox常用设置

	$ mkdir -p ~/.config/openbox
	$ cp /etc/xdg/openbox/{rc.xml,menu.xml,autostart,environment} ~/.config/openbox

	autostart文件：
	pcmanfm --desktop &
	tint2 &
	
	#debian
	#volti &
	
	# Volume
	if which volumeicon >/dev/null 2>&1; then
       		volumeicon &
	fi

	#feh --bg-scale ~/Downloads/dp.jpg
	fcitx &
	#conky&amp;

	rc.xml文件：
<!-- Keybindings for running applications -->
<keybind key="A-r">
<action name="Execute">
<execute>dmenu_run</execute>
</action>
</keybind>
<keybind key="A-space">
<action name="Execute">
<execute>uxterm</execute>
</action>
</keybind>
<keybind key="A-Up">
<action name="Execute">
<command>amixer set Master 5%+</command>
</action>
</keybind>
<keybind key="A-Down">
<action name="Execute">
<command>amixer set Master 5%-</command>
</action>
</keybind>
<keybind key="A-m">
<action name="Execute">
<command>amixer set Master toggle</command>
</action>
</keybind>
 <keybind key="Print">
      <action name="Execute">
         <startupnotify>
           <enabled>false</enabled>
           <name>Snapshot</name>
        </startupnotify>
         <command>scrot images.png</command>
       </action>
     </keybind>
     <keybind key="S-Print">
       <action name="Execute">
         <startupnotify>
           <enabled>false</enabled>
           <name>Snapshot with Frame</name>
         </startupnotify>
         <command>scrot -bs images.png</command>
       </action>
     </keybind>
     <keybind key="C-Print">
       <action name="Execute">
         <startupnotify>
           <enabled>false</enabled>
           <name>Snapshot Fullscreen</name>
         </startupnotify>
         <command>scrot -s images.png</command>
       </action>
     </keybind>



	menu.xml文件：

<menu id="exit-menu" label="Exit">
<item label="Log Out">
<action name="Execute">
<command>openbox --exit</command>
</action>
</item>
<item label="Shutdown">
<action name="Execute">
<command>systemctl poweroff</command>
</action>
</item>
<item label="Restart">
<action name="Execute">
<command>systemctl reboot</command>
</action>
</item>
<item label="Suspend">
<action name="Execute">
<command>systemctl suspend</command>
</action>
</item>
<item label="Hibernate">
<action name="Execute">
<command>systemctl hibernate</command>
</action>
</item>
</menu>
