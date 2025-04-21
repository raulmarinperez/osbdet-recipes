#!/bin/bash

CURRENT_PATH=$(dirname $(realpath $0))
LOG_FILE=/tmp/kubernetes_intall.log

REQUIRED_GO_VERSION="1.17"

GO_PATH=/usr/local/go/bin/go
GO_ARM64_BINARY_URL=https://go.dev/dl/go1.23.4.linux-arm64.tar.gz
GO_ARM64_BINARY_TGZ=go1.23.4.linux-arm64.tar.gz
GO_AMD64_BINARY_URL=https://go.dev/dl/go1.23.4.linux-amd64.tar.gz
GO_AMD64_BINARY_TGZ=go1.23.4.linux-amd64.tar.gz

KIND_ARM64_BINARY_URL=https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-arm64
KIND_AMD64_BINARY_URL=https://kind.sigs.k8s.io/dl/v0.27.0/kind-linux-amd64

KUBECTL_ARM64_BINARY_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
KUBECTL_AMD64_BINARY_URL="https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

HELM_ARM64_BINARY_URL=https://get.helm.sh/helm-v3.17.2-linux-arm64.tar.gz
HELM_AMD64_BINARY_URL=https://get.helm.sh/helm-v3.17.2-linux-amd64.tar.gz

K9S_ARM64_BINARY_URL=https://github.com/derailed/k9s/releases/download/v0.40.10/k9s_Linux_arm64.tar.gz
K9S_AMD64_BINARY_URL=https://github.com/derailed/k9s/releases/download/v0.40.10/k9s_Linux_amd64.tar.gz

# Kubernetes recipe's entry point
#

echo "  Starting the "kubernetes" recipe (see $LOG_FILE for more info)..."

#!/bin/bash

# install_check_golang_version
#   desc: Check if the installed Go version is greater than or equal to the required version
#   params:
#     none
check_golang_version(){

  installed_version=$($GO_PATH version | awk '{print $3}' | sed 's/^go//')  

  # Use sort for numeric comparison
  if [[ "$(printf '%s\n%s' "$installed_version" "$REQUIRED_GO_VERSION" | sort -V | head -n 1)" == "$installed_version" ]]; then
    if [[ "$installed_version" == "$REQUIRED_GO_VERSION" ]]; then
      return 0 # Equal
    else
      return 1 # installed_version is less than REQUIRED_GO_VERSION
    fi
  else
    return 2 # installed_version is greater than REQUIRED_GO_VERSION
  fi
}

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

# check_and_install_golang
#   desc: Install go binaries from the official website
#   params:
#     none
check_and_install_golang(){
  if [ -f "$GO_PATH" ]; then
    # go-lang is already installed
    check_golang_version
    comparison_result=$?
    if [[ $comparison_result -eq 2 ]]; then
      echo "Go version $installed_version is newer than $required_version... version kept"
    else
      echo "Go version $installed_version is not newer than $required_version... installing the a newer one"
      install_golang
    fi
  else
    # go-lang is not installed, so install it
    install_golang
  fi
}

# install_kind
#   desc: Install kind according to the official website
#   params:
#     none
install_kind(){
  # Grab the right binary
  if [ "$ARCH" == "aarch64" ]
  then
    curl -Lo ./kind $KIND_ARM64_BINARY_URL
  elif [ "$ARCH" == "x86_64" ]
  then
    curl -Lo ./kind $KIND_AMD64_BINARY_URL
  fi
  # Move the binary to the PATH
  chmod +x ./kind
  sudo mv ./kind /usr/local/bin/kind
}

# install_kubectl
#   desc: Install kubectl according to the official website
#   params:
#     none
install_kubectl(){
  # Grab the right binary
  if [ "$ARCH" == "aarch64" ]
  then
    curl -LO $KUBECTL_ARM64_BINARY_URL
  elif [ "$ARCH" == "x86_64" ]
  then
    curl -LO $KUBECTL_AMD64_BINARY_URL
  fi
  # Move the binary to the PATH
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  sudo rm kubectl
}

# install_helm
#   desc: Install helm according to the official website
#   params:
#     none
install_helm(){
  # Grab the right binary
  if [ "$ARCH" == "aarch64" ]
  then
    curl -Ls $HELM_ARM64_BINARY_URL | tar -xz --wildcards linux-arm64/helm --strip-components=1 
  elif [ "$ARCH" == "x86_64" ]
  then
    curl -Ls $HELM_AMD64_BINARY_URL | tar -xz --wildcards linux-amd64/helm --strip-components=1 
  fi
  # Move the binary to the PATH
  sudo install -o root -g root -m 0755 helm /usr/local/bin/helm
  sudo rm helm
}

# install_k9s
#   desc: Install k9s according to the official website
#   params:
#     none
install_k9s(){
  # Grab the right binary
  if [ "$ARCH" == "aarch64" ]
  then
    curl -Ls $K9S_ARM64_BINARY_URL | tar -xz --wildcards k9s 
  elif [ "$ARCH" == "x86_64" ]
  then
    curl -Ls $K9S_AMD64_BINARY_URL | tar -xz --wildcards k9s
  fi
  # Move the binary to the PATH
  sudo install -o root -g root -m 0755 k9s /usr/local/bin/k9s
  sudo rm k9s
}

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
#   1. Install go-lang binaries if needed
#   2. Install kind
#   3. Install kubectl
#   4. Install helm
#   5. Install k9s
printf "    - Install Go language (if needed)... "
check_and_install_golang >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install kind... "
install_kind >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install kubectl... "
install_kubectl >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install helm... "
install_helm >> $LOG_FILE 2>&1
printf "[Done]\n"
printf "    - Install k9s... "
install_k9s >> $LOG_FILE 2>&1
printf "[Done]\n"

echo "  'kubernetes' recipe successfully installed"
