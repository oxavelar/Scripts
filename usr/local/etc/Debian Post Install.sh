#!/bin/bash

# Install Google Chrome & Google Music : Now in Contrib
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo -e "deb http://dl.google.com/linux/chrome/deb/ stable main
deb http://dl.google.com/linux/musicmanager/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google.list

# sudo vim /etc/apt/sources.list
#
#
#
# deb http://deb.debian.org/debian/ testing main contrib non-free
# deb-src http://deb.debian.org/debian/ testing main contrib non-free
# 
# deb http://deb.debian.org/debian-security testing/updates main contrib non-free
# deb-src http://deb.debian.org/debian-security testing/updates main contrib non-free
# 
# deb http://deb.debian.org/debian/ testing-updates main contrib non-free
# deb-src http://deb.debian.org/debian/ testing-updates main contrib non-free
# 
# deb http://www.deb-multimedia.org testing main non-free


# Minimal Gnome
sudo apt-get purge gnome-games rhythmbox* empathy* ekiga* gnome-ppp tomboy mutt ppp sound-juicer simple-scan xboard quadrapassel four-in-a-row swell-foop lightsoff tali iagno reportbug shotwell && sudo apt-get install gnome-core && sudo apt-get autoremove
#&& sudo aptitude keep-all && sudo apt-get autoremove

# Installing some common applications I use
sudo apt-get update
sudo apt-get install unrar p7zip pigz wireshark vim vim-syntastic vlc banshee pidgin inkscape gimp rsync google-chrome-beta git transmission-gtk gedit-source-code-browser-plugin zip bash-completion

# Make vim default text editor
sudo update-alternatives --config editor

# NFS sharing drives
sudo apt-get install nfs-common nfs-kernel-server
echo -e "
/home/omar\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)
/media/Files\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)
/media/External\t\t10.0.0.0/16(rw,sync,no_subtree_check,crossmnt,no_root_squash)" | sudo tee -a /etc/exports
