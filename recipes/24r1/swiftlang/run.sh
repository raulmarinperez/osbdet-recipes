#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
LOG_FILE=/tmp/swift_intall.log

# add_swiftlang_repo
#   desc: Add Swift Community APT Repository
#   params:
#     none
add_swiftlang_repo(){
  curl -s https://archive.swiftlang.xyz/install.sh | sudo bash
}

# install_swift
#   desc: Install Swift
#   params:
#     none
install_swift(){
  apt update
  apt install swiftlang -y
}

# Swiftlang recipe's entry point
#

echo "  Starting the "swiftlang" recipe (see $LOG_FILE for more info)..."

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
#   1. Add Swift Community APT Repository
#   2. Install Swift
# * Inspired by this article: https://swiftlang.xyz/user-guide/
printf "    - Add Swift Community APT Repository... "
add_swiftlang_repo >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install Swift... "
install_swift >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'swiftlang' recipe successfully installed"
