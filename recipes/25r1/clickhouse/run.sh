#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
LOG_FILE=/tmp/clickhouse_intall.log

# download_clickhouse_binary
#   desc: Download Clickhouse binary to /tmp as indicated in the documentation
#   params:
#     none
download_clickhouse_binary(){
  cd /tmp
  curl https://clickhouse.com/ | sh
}

# install_clickhouse
#   desc: Install Clickhouse binary
#   params:
#     none
install_clickhouse(){
  sudo /tmp/clickhouse install
  sudo rm -rf /tmp/clickhouse
}

# Clickhouse recipe's entry point
#

echo "  Starting the "clickhouse" recipe (see $LOG_FILE for more info)..."

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
#   1. Download Clickhouse binary
#   2. Install binary file
# * Inspired by this article: https://www.linuxtechi.com/how-to-install-terraform-on-debian/?utm_content=cmp-true
printf "    - Downloading the binary file... "
download_clickhouse_binary >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Installing binary files... "
install_clickhouse >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'clickhouse' recipe successfully installed"
