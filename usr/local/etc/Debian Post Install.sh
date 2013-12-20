#!/bin/bash

# Install Google Chrome & Google Music
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo -e "deb http://dl.google.com/linux/chrome/deb/ stable main
deb http://dl.google.com/linux/musicmanager/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

sudo apt-get purge rhythmbox iceweasel ekiga icedtea-* gnome-ppp
sudo aptitude keep-all

# Installing some common applications I use
sudo apt-get update
sudo apt-get install unrar p7zip wireshark vim xscreensaver-gl-extra vlc banshee pidgin inkscape gimp rsync google-chrome-beta git

# NFS sharing drives
sudo apt-get install nfs-common nfs-kernel-server
echo -e "
/home/omar\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)
/media/Files\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)
/media/External\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)" | sudo tee -a /etc/exports
