#!/bin/bash

# Install Google Chrome & Google Music : Now in Contrib
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo -e "deb http://dl.google.com/linux/chrome/deb/ stable main
deb http://dl.google.com/linux/musicmanager/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

# sudo vim /etc/apt/sources.list
#
# deb http://ftp.us.debian.org/debian/ testing main contrib non-free
# deb-src http://ftp.us.debian.org/debian/ testing main contrib non-free
#
# deb http://security.debian.org/ testing/updates main
# deb-src http://security.debian.org/ testing/updates main
#
# deb http://ftp.us.debian.org/debian/ testing-updates main
# deb-src http://ftp.us.debian.org/debian/ testing-updates main
#
# deb http://www.deb-multimedia.org testing main non-free

sudo apt-get purge rhythmbox iceweasel ekiga icedtea-* gnome-ppp gnome-games tomboy mutt pidgin ppp sound-juicer transmission-* simple-scan avahi-daemon bluez && sudo aptitude keep-all && sudo apt-get autoremove

# Installing some common applications I use
sudo apt-get update
sudo apt-get install unrar p7zip pigz wireshark vim vim-gnome vlc banshee pidgin inkscape gimp rsync google-chrome-beta git transmission-gtk

# NFS sharing drives
sudo apt-get install nfs-common nfs-kernel-server
echo -e "
/home/omar\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)
/media/Files\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)
/media/External\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)" | sudo tee -a /etc/exports
