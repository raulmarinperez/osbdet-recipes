#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
LOG_FILE=/tmp/terraform_intall.log

# add_hashicorp_repo
#   desc: Add Hashicorp APT Repository
#   params:
#     none
add_hashicorp_repo(){
  wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
}

# install_terraform
#   desc: Install Terraform
#   params:
#     none
install_terraform(){
  apt update
  apt install terraform -y
}

# Terraform recipe's entry point
#

echo "  Starting the "terraform" recipe (see $LOG_FILE for more info)..."

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
#   1. Add Hashicorp APT Repository
#   2. Install Terraform
# * Inspired by this article: https://www.linuxtechi.com/how-to-install-terraform-on-debian/?utm_content=cmp-true
printf "    - Add Hashicorp APT Repository... "
add_hashicorp_repo >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install Terraform... "
install_terraform >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'terraform' recipe successfully installed"
