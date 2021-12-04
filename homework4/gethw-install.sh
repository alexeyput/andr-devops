#!/bin/bash

# Simple artefact installation script.
# No checking performed

# Check root privileges
 if [ $(id -u) != 0 ]
   then
     echo "Insufficient privileges. Root access is required to run this script"
     exit 1
 fi

 if [ ! -d /opt/gethw-tg ]
  then
    mkdir -p /opt/gethw-tg
 fi

useradd -M  -s /usr/sbin/nologin gethw-tg

yes | cp -rf ./gethw-tg  /opt/gethw-tg
yes | cp -rf ./gethw-tg.yaml /opt/gethw-tg
yes | cp -rf ./gethw-tg.service /etc/systemd/system

chown -R gethw-tg:gethw-tg /opt/gethw-tg
chmod -R 775 /opt/gethw-tg

systemctl daemon-reload
systemctl start gethw-tg
systemctl enable gethw-tg

exit 0