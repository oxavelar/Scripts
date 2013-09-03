#! /bin/sh
### BEGIN INIT INFO
# Provides:          /etc/init.d/ramdisk.sh
# Required-Start:    $local_fs
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Using ccache in /var/tmp, this preloads it.
#                    Files are stored with pigz because of the
#                    multiprocess nature of pigz and to do less
#                    disk usage.
### END INIT INFO

# Prioritizing rsync's IO & CPU resources
ionice -c2 -n7 -p $$

RAMDISK_PATH="/var/tmp/ccache/"
PERDISK_PATH="/home/visitor/.ccache/"

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

case "$1" in
  start)
    log_success_msg "Filling files from disk to ramdrive"
    mkdir $RAMDISK_PATH > /dev/null 2>&1
    #rsync -a $PERDISK_PATH $RAMDISK_PATH
    tar -I pigz -xf $PERDISK_PATH/ccache.tar.pz -C /
    log_action_msg "Ramdisk synched from original backup"
    ;;
  sync)
    log_success_msg "Synching files from ramdisk to disk"
    #rsync -a --delete --recursive --force $RAMDISK_PATH $PERDISK_PATH
    tar -I pigz -cf $PERDISK_PATH/ccache.tar.pz $RAMDISK_PATH
    log_action_msg "Ramdisk synched to drive"
    ;;
  stop)
    log_success_msg "Synching logfiles from ramdisk to disk"
    #rsync -a --delete --recursive --force $RAMDISK_PATH $PERDISK_PATH
    tar -I pigz -cf $PERDISK_PATH/ccache.tar.pz.tmp $RAMDISK_PATH
    mv -f $PERDISK_PATH/ccache.tar.pz.tmp $PERDISK_PATH/ccache.tar.pz
    log_action_msg "Backing up ramdisk contents to drive"
    ;;
  *)
    echo "Usage: /etc/init.d/ramdisk {start|stop|sync}"
    exit 1
    ;;
esac

exit 0

