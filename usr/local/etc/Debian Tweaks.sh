#!/bin/sh

sudo echo "Custom tweak script for Debian Linux - by Omar X. Avelar"

# Use the same themes and similar settings
# for the root user.
sudo ln -s ~/.themes /root/.themes
sudo ln -s ~/.icons /root/.icons
sudo ln -sf ~/.vimrc /root/.vimrc
sudo ln -sf ~/.viminfo /root/.viminfo
sudo ln -sf ~/.pythonrc /root/.pythonrc
sudo ln -sf ~/.bashrc /root/.bashrc
sudo ln -sf ~/.bash_aliases /root/.bash_aliases

# Rebuild fonts cache.
sudo dpkg-reconfigure fontconfig-config
sudo dpkg-reconfigure fontconfig
sudo fc-cache

# Defines root password.
sudo passwd root

# Use less TTY consoles -- maybe 2.
sudo vim /etc/default/console-setup
sudo vim /etc/inittab

# Manual CPU Scaling governor.
sudo dpkg-reconfigure gnome-applets

# Hibernate file to HDD for sure.
#sudo gedit /etc/initramfs-tools/conf.d/resume
#sudo update-initramfs -u
