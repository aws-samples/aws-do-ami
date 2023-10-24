#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

# Parse arguments
NVIDIA_DRIVER_VERSION=$1
if [ "$NVIDIA_DRIVER_VERSION" == "" ]; then
    NVIDIA_DRIVER_VERSION=535.54.03
fi

FABRIC_MANAGER_VERSION=$2
if [ "$FABRIC_MANAGER_VERSION" == "" ]; then
    FABRIC_MANAGER_VERSION=535.54.03
fi

CUDA_TOOLKIT_VERSION=$3
if [ "$CUDA_TOOLKIT_VERSION" == "" ]; then
    CUDA_TOOLKIT_VERSION=12-2
fi

# clean up existing Nvidia driver 
PACKAGE_NAME="nvidia-driver"

if yum list installed 2>/dev/null | grep -q "^$PACKAGE_NAME"; then
    echo "$PACKAGE_NAME is installed. Proceeding to uninstall."
    sudo yum erase -y $PACKAGE_NAME-*
    echo "Uninstall complete."
else
    echo "$PACKAGE_NAME is not installed."
fi

NVIDIA_REPO="/etc/yum.repos.d/amzn2-nvidia.repo"
if [ -e "$NVIDIA_REPO" ]; then
    sudo rm "$NVIDIA_REPO"
    echo "$NVIDIA_REPO has been removed."
else
    echo "$NVIDIA_REPO does not exist."
fi

# Install the Nvidia driver
cd /tmp
sudo yum install gcc10 rsync dkms -y
sudo wget -O /tmp/NVIDIA-Linux-driver.run "https://us.download.nvidia.com/tesla/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
sudo CC=gcc10-cc sh /tmp/NVIDIA-Linux-driver.run -q -a --ui=none
# You should see 
# Installation of the NVIDIA Accelerated Graphics Driver for Linux-x86_64 (version: 535.54.03) is now complete.

# Install FabricManager
sudo curl -O https://developer.download.nvidia.com/compute/nvidia-driver/redist/fabricmanager/linux-x86_64/fabricmanager-linux-x86_64-${FABRIC_MANAGER_VERSION}-archive.tar.xz
sudo tar xf fabricmanager-linux-x86_64-${FABRIC_MANAGER_VERSION}-archive.tar.xz -C /tmp
sudo rsync -al /tmp/fabricmanager-linux-x86_64-${FABRIC_MANAGER_VERSION}-archive/ /usr/ --exclude LICENSE
sudo mv /usr/systemd/nvidia-fabricmanager.service /usr/lib/systemd/system
sudo systemctl enable nvidia-fabricmanager

# Install CUDA tooklit
sudo yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
sudo yum clean all
sudo yum install libglvnd-glx cuda-toolkit-${CUDA_TOOLKIT_VERSION} -y

# Install nvidia-container-toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.repo | sudo tee /etc/yum.repos.d/nvidia-docker.repo
sudo yum install -y nvidia-container-toolkit
sed -i "s|/etc/docker-runtimes.d/nvidia|/usr/bin/nvidia-container-runtime|g" /etc/containerd/config.toml
systemctl restart containerd

