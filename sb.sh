#!/bin/bash
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo 'exec openbox-session'>>~/.xinitrc

sudo cp -r /root/debian/openbox ~/.config
startx