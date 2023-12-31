#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
LOG_FILE=/tmp/osbdetweb_intall.log

# install_nodejs20
#   desc: Install Node.js 20 binaries
#   params:
#     none
install_nodejs20(){
   # Installation instructions documented at https://github.com/nodesource/distributions#debinstall
   curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
   echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
   apt-get update
   apt-get install -y nodejs
}

# OSBDET web installer's entry point
#

echo "  Starting the 'osbdetweb' recipe (see /tmp/osbdetweb_intall.log for more info)..."

# Identify which architecture OSBDET is running on
ARCH=`uname -m`
if [ "$ARCH" == "aarch64" ]
then
  echo "    - You're "cooking" this "recipe" on a ARM64 machine"
elif [ "$ARCH" == "x86_64" ]
then
  echo "    - You're "cooking" this "recipe" on a AMD64 machine"
else
  echo "ERROR: Architecture not supported. Installation aborted!"
  exit 1
fi

# Recipe cooking:
#   1. Install Node.js 20 (already installed)
#   2. 
printf "    - Node.js 20 installation... "
#install_nodejs20 >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'osbdetweb' recipe successfully installed"