#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
VSCODE_DEB_FILE=/tmp/vscode_install.deb
VSCODE_BIN=/usr/share/code/bin/code
VSCODE_SERVICE=vsctunnel.service
LOG_FILE=/tmp/vscodetunnel_intall.log

trap ctrl_c INT

# ctrl_c
#   desc: tunnel registration has to be finished by clicking Ctrl+C as
#         there is no way to run it as a one-shot command
#   params:
#     none
function ctrl_c() {
  killall code-tunnel
  echo "  VS Code tunnel and associated Linux service installed!"
}

# download_aarch64_installer
#   desc: download the ARM64 installer and make it available as $VSCODE_DEB_FILE
#   params:
#     none
download_aarch64_installer(){
  printf "    - Downloading the ARM64 version of the installer "  
  wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64" -O $VSCODE_DEB_FILE >> $LOG_FILE 2>&1
  printf "[Done]\n"
}

# download_amd64_installer
#   desc: download the AMD64 installer and make it available as $VSCODE_DEB_FILE
#   params:
#     none
download_amd64_installer(){
  printf "    - Downloading the AMD64 version of the installer "  
  wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O $VSCODE_DEB_FILE >> $LOG_FILE 2>&1
  printf "[Done]\n"
}

# install_vscode
#   desc: Install VSCode based on the official documentation (check the website)
#   params:
#     none
install_vscode(){
  if [ -f $VSCODE_DEB_FILE ]
  then
    printf "    - Starting package installation: "
    apt install -y $VSCODE_DEB_FILE >> $LOG_FILE 2>&1
    printf "[Done]\n"
  else
    echo "    ERROR: installation file not available"
    exit 1
  fi
}

# install_vscode_service
#   desc: Install the vscode service to automatically initiate the tunnel
#   params:
#     none
install_vscode_service(){
  if [ -f $VSCODE_BIN ]
  then
    printf "    - Creating the VS Code tunnel service... "
    cp $CURRENT_PATH/$VSCODE_SERVICE /lib/systemd/system/$VSCODE_SERVICE >> $LOG_FILE 2>&1
    systemctl enable `basename -- "$VSCODE_SERVICE" .service` >> $LOG_FILE 2>&1
    printf "[Done]\n"
  else
    echo "    ERROR: VS Code binary not found, review the log file for more info"
    exit 1
  fi
}

# configure_tunnel
#   desc: Configure the VS Code tunnel as osbdet user
#   params:
#     none
configure_tunnel(){
  if [ -f $VSCODE_BIN ]
  then
    echo "    - Configuring VS Code tunnel for user 'osbdet':"
    echo "      * Note: once configured, leave the script by clicking Ctrl+C (there is not option for one-shot execution)"

    # Ask for the name of the tunnel
    NAME=""
    while [ "$NAME" == "" ];
    do
      read -p "      Choose a tunnel name (no spaces nor special characters (ex. osbdet-rmarin) : " NAME
      su - osbdet -c "/usr/share/code/bin/code tunnel --name $NAME --accept-server-license-terms"
    done
  else
    echo "    ERROR: VS Code binary not found, review the log file for more info"
    exit 1
  fi
}

# VSCode tunnel recipe's entry point
#

echo "  Starting the "vscodetunnel" recipe (see /tmp/vscodetunnel_intall.log for more info)..."

# Identify which architecture OSBDET is running on
ARCH=`uname -m`
if [ "$ARCH" == "aarch64" ]
then
  download_aarch64_installer
  install_vscode
  install_vscode_service
  configure_tunnel
elif [ "$ARCH" == "x86_64" ]
then
  download_amd64_installer
  install_vscode
  install_vscode_service
  configure_tunnel
else
  echo "Architecture not supported"
  exit 1
fi

