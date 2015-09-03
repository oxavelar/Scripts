#!/bin/bash

SERIAL_DEV="$(ls -d /dev/ttyUSB?)"

# At least one USB serial device
if [ "$SERIAL_DEV" == "" ]; then
    echo "E: No /dev/ttyUSB* devices found"
    exit -127
fi

# Make sure we have cu installed
which screen
if [ "$?" -ne "0" ]; then
    sudo apt-get install -y screen
fi

clear
echo "Executing call up through $SERIAL_DEV..."
sudo chown uucp: $SERIAL_DEV && sudo screen $SERIAL_DEV 115200
