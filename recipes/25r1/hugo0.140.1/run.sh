#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
LOG_FILE=/tmp/hugo_intall.log

GO_ARM64_BINARY_URL=https://go.dev/dl/go1.23.4.linux-arm64.tar.gz
GO_ARM64_BINARY_TGZ=go1.23.4.linux-arm64.tar.gz
GO_AMD64_BINARY_URL=https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
GO_AMD64_BINARY_TGZ=go1.23.4.linux-amd64.tar.gz

HUGO_ARM64_DEB_URL=https://github.com/gohugoio/hugo/releases/download/v0.140.1/hugo_extended_0.140.1_linux-arm64.deb
HUGO_ARM64_DEB_FILE=hugo_extended_0.140.1_linux-arm64.deb
HUGO_AMD64_DEB_URL=https://github.com/gohugoio/hugo/releases/download/v0.140.1/hugo_extended_0.140.1_linux-amd64.deb
HUGO_AMD64_DEB_FILE=hugo_extended_0.140.1_linux-amd64.deb

# install_golang
#   desc: Install go binaries from the official website
#   params:
#     none
install_golang(){
  # Remove previous versions
  echo "Removing previous versions..."
  rm -rf /usr/local/go
  # Install the right binaries
  if [ "$ARCH" == "aarch64" ]
  then
    echo "Downloading $GO_ARM64_BINARY_URL ..."
    wget $GO_ARM64_BINARY_URL -O /tmp/$GO_ARM64_BINARY_TGZ
    echo "Unpacking /tmp/$GO_ARM64_BINARY_TGZ ..."
    tar -C /usr/local -xzf /tmp/$GO_ARM64_BINARY_TGZ
    echo "Removing /tmp/$GO_ARM64_BINARY_TGZ ..."
    rm /tmp/$GO_ARM64_BINARY_TGZ
  elif [ "$ARCH" == "x86_64" ]
  then
    echo "Downloading $GO_AMD64_BINARY_URL ..."
    wget $GO_AMD64_BINARY_URL -O /tmp/$GO_AMD64_BINARY_TGZ
    echo "Unpacking /tmp/$GO_AMD64_BINARY_TGZ ..."
    tar -C /usr/local -xzf /tmp/$GO_AMD64_BINARY_TGZ
    echo "Removing /tmp/$GO_AMD64_BINARY_TGZ ..."
    rm /tmp/$GO_AMD64_BINARY_TGZ
  fi
  # Add go-lang to the PATH if it wasn't added yet
  if grep -q "# Add go-lang to the PATH" /home/osbdet/.profile; then
    echo "Go-lang is already in the PATH!"
  else
    echo "Adding go-lang to the PATH..."
    echo -e '\n# Add go-lang to the PATH' >> /home/osbdet/.profile
    echo 'export PATH=$PATH:/usr/local/go/bin' >> /home/osbdet/.profile
  fi
}

# install_hugo
#   desc: Install hugo from the official website
#   params:
#     none
install_hugo(){
    # Install the right binaries
  if [ "$ARCH" == "aarch64" ]
  then
    echo "Downloading $HUGO_ARM64_DEB_URL ..."
    wget $HUGO_ARM64_DEB_URL -O /tmp/$HUGO_ARM64_DEB_FILE
    echo "Installing /tmp/$HUGO_ARM64_DEB_FILE ..."
    dpkg -i /tmp/$HUGO_ARM64_DEB_FILE
    echo "Removing /tmp/$HUGO_ARM64_DEB_FILE ..."
    rm /tmp/$HUGO_ARM64_DEB_FILE
  elif [ "$ARCH" == "x86_64" ]
  then
    echo "Downloading $HUGO_AMD64_DEB_URL ..."
    wget $HUGO_AMD64_DEB_URL -O /tmp/$HUGO_AMD64_DEB_FILE
    echo "Installing /tmp/$HUGO_AMD64_DEB_FILE ..."
    dpkg -i /tmp/$HUGO_AMD64_DEB_FILE
    echo "Removing /tmp/$HUGO_AMD64_DEB_FILE ..."
    rm /tmp/$HUGO_AMD64_DEB_FILE
  fi
}

# Hugo recipe's entry point
#

echo "  Starting the "hugo" recipe (see $LOG_FILE for more info)..."

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
#   1. Install go-lang binaries
#   2. Install Terraform
# * Inspired by these references:
#   - https://go.dev/doc/install
#   - https://github.com/gohugoio/hugo/releases/tag/v0.140.1
printf "    - Install Go language... "
install_golang >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install Hugo... "
install_hugo >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'hugo' recipe successfully installed"
