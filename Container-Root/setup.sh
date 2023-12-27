#!/bin/sh

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

if [ -d /etc/apt ]; then
        [ -n "$http_proxy" ] && echo "Acquire::http::proxy \"${http_proxy}\";" > /etc/apt/apt.conf; \
        [ -n "$https_proxy" ] && echo "Acquire::https::proxy \"${https_proxy}\";" >> /etc/apt/apt.conf; \
        [ -f /etc/apt/apt.conf ] && cat /etc/apt/apt.conf
fi

# Install basic tools
echo ""
echo "Installing basic tools ..."
apt-get update
apt-get install -y vim nano jq less gettext-base tree

# Install AWS CLI v2
echo ""
echo "Installing AWS CLI version 2"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
rm -rf aws awscliv2.zip

# Install Packer
echo ""
echo "Installing Packer ..."
PACKER_VERSION="1.9.4"
PACKER_VERSION_SHA256SUM="6cd5269c4245aa8c99e551d1b862460d63fe711c58bec618fade25f8492e80d9"
curl -O https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip
echo "${PACKER_VERSION_SHA256SUM}  packer_${PACKER_VERSION}_linux_amd64.zip" > checksum && sha256sum -c checksum
unzip packer_${PACKER_VERSION}_linux_amd64.zip
ln -s $PWD/packer /usr/sbin/packer
rm -f packer_${PACKER_VERSION}_linux_amd64.zip

# Install Ansible
pip install ansible

# Install Session Manager Plugin
echo "Installing Session Manager Plugin ..."
curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb"
dpkg -i session-manager-plugin.deb
rm -f ./session-manager-plugin.deb

# Install yq
YQ_VERSION=4.21.1
wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -O /usr/bin/yq
chmod +x /usr/bin/yq

# Configure .bashrc
echo "alias ll='ls -alh --color=auto'" >> /root/.bashrc

