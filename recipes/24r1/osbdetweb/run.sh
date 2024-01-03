#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
OSBDETWEB_HOME=/opt/osbdetweb
LOG_FILE=/tmp/osbdetweb_intall.log

# install_nodejs20
#   desc: Install Node.js 20 binaries
#   params:
#     none
install_nodejs20(){
  if [ ! -f /usr/bin/node ]
  then
    # Installation instructions documented at https://github.com/nodesource/distributions#debinstall
    # The "chromium" package will be needed if decktape (PDF printing) is needed (ex. slides)
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
    apt-get update
    apt-get install -y nodejs chromium
   else
    echo "WARNING: Node.js already installed, installation skipped."
   fi
}

# deploy_osbdetweb
#   desc: Deploy the OSBDET web application under /opt. Steps to deploy it:
#           1. Copy the contents of the Web App
#           2. Install dependencies via NPM
#           3. Build the Web App with NPM
#           4. Change ownership to the osbdet user
#   params:
#     none
deploy_osbdetweb(){
  if [ ! -d $OSBDETWEB_HOME ]
  then
    cp -rf $CURRENT_PATH/content $OSBDETWEB_HOME
    cd $OSBDETWEB_HOME
    npm install
    npm run build
    chown -R osbdet:osbdet $OSBDETWEB_HOME
  else
    echo "WARNING: OSBDET web folder already exists, deployment skipped."
  fi
}

# osbdetweb_service_install
#   desc: OSBDET service installation
#   params:
#     none
osbdetweb_service_install(){
  cp $CURRENT_PATH/osbdetweb.service /lib/systemd/system/osbdetweb.service
  chmod 644 /lib/systemd/system/osbdetweb.service
  systemctl daemon-reload
  systemctl enable osbdetweb.service
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
#   2. Deploy the OSBDET web app
#   3. OSBDET web service installation
printf "    - Node.js 20 installation... "
install_nodejs20 >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - OSBDET web deployment... "
deploy_osbdetweb >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - OSBDET web service installation... "
osbdetweb_service_install >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'osbdetweb' recipe successfully installed"