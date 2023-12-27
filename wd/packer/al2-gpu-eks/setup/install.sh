#!/bin/bash

#set -x

source /tmp/install-versions.sh

echo ""
date
echo "Executing install.sh ..."
echo ""
echo NVIDIA_DRIVER_VERSION=$NVIDIA_DRIVER_VERSION
echo FABRIC_MANAGER_VERSION=$FABRIC_MANAGER_VERSION
echo CUDA_TOOLKIT_VERSION=$CUDA_TOOLKIT_VERSION
echo EFA_VERSION=$EFA_VERSION
echo HWLOC_VERSION=$HWLOC_VERSION
echo AWS_OFI_NCCL_VERSION=$AWS_OFI_NCCL_VERSION
echo NCCL_VERSION=$NCCL_VERSION
echo NCCL_TEST_VERSION=$NCCL_TEST_VERSION

# Kill any processes that use nvidia
echo ""
echo "Stopping processes using nvidia driver ..."
ps -aef | grep [n]vidia | awk '{print $2}' | grep -v grep | xargs kill -9

# Note:
# The source AMI already contains the right version of NVIDIA driver, FabricManager, CUDA Toolkit, and NVIDIA Container Toolkit. Uninstalling the NVIDIA driver removes the nvidia container runtime, followed by dependency issues when reinstalling it. Therefore it is recommended to use a source AMI that already has these components installed and only install or upgrade the AWS specific ones. The code to install NVIDIA components is provided here for completeness, but is commented out as we rely on the right versions of these components being already present in the AMI.

# Remove existing NVIDIA driver if present
#if yum list installed 2>/dev/null | grep -q "^nvidia-driver"; then
#    echo ""
#    echo "Removing existing nvidia driver ..."
#    yum erase -y nvidia-driver-* -q
#    rm /etc/yum.repos.d/amzn2-nvidia.rep
#fi

# Install tools
echo ""
echo "Installing tools ..."
yum install gcc10 rsync dkms git -y -q

# NVIDIA driver
#echo ""
#echo "Installing NVIDIA driver ..."
#cd /tmp
#wget -q -O NVIDIA-Linux-driver.run "https://us.download.nvidia.com/tesla/${NVIDIA_DRIVER_VERSION}/NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run"
#CC=gcc10-cc sh NVIDIA-Linux-driver.run -s -a --ui=none
#rm NVIDIA-Linux-driver.run

# Install FabricManager
#echo ""
#echo "Installing FabricManager ..."
#cd /tmp
#curl -s -O https://developer.download.nvidia.com/compute/nvidia-driver/redist/fabricmanager/linux-x86_64/fabricmanager-linux-x86_64-${FABRIC_MANAGER_VERSION}-archive.tar.xz
#tar -xf fabricmanager-linux-x86_64-${FABRIC_MANAGER_VERSION}-archive.tar.xz
#rsync -al fabricmanager-linux-x86_64-${FABRIC_MANAGER_VERSION}-archive/ /usr/ --exclude LICENSE
#mv -f /usr/systemd/nvidia-fabricmanager.service /usr/lib/systemd/system
#systemctl enable nvidia-fabricmanager
#systemctl daemon-reload
#systemctl restart nvidia-fabricmanager
#rm -rf fabricmanager-linux*

# Install CUDA Toolkit
#echo ""
#echo "Installing CUDA Toolkit ..."
#if ${INSTALL_NVIDIA_CUDA_TOOLKIT:-true}; then
#  yum-config-manager --add-repo https://developer.download.nvidia.com/compute/cuda/repos/rhel7/x86_64/cuda-rhel7.repo
#  yum clean all -q
#  yum install libglvnd-glx cuda-toolkit-${CUDA_TOOLKIT_VERSION} -y -q
#fi

# Install NVIDIA Container Tooolkit
#echo ""
#echo "Installing NVIDIA Container Toolkit ..."
#if ${INSTALL_NVIDIA_CONTAINER_TOOLKIT:-true}; then
#  DISTRIBUTION=$(. /etc/os-release;echo $ID$VERSION_ID)
#  curl -s -L https://nvidia.github.io/nvidia-docker/${DISTRIBUTION}/nvidia-docker.repo | tee /etc/yum.repos.d/nvidia-docker.repo
#  yum install -y nvidia-container-toolkit -q
#fi

# Install EFA
echo ""
echo "Installing EFA ..."
curl -s -O https://efa-installer.amazonaws.com/aws-efa-installer-${EFA_VERSION}.tar.gz
tar -xf aws-efa-installer-${EFA_VERSION}.tar.gz && cd aws-efa-installer
./efa_installer.sh -y -g
cd /tmp
rm -rf /aws-efa-installer*
# Validate
/opt/amazon/efa/bin/fi_info fi_info -p efa -t FI_EP_RDM

# Install HWLOC
# hwloc - https://www.open-mpi.org/projects/hwloc/tutorials/20120702-POA-hwloc-tutorial.html
echo ""
echo "Installing HWLOC ..."
wget -q https://download.open-mpi.org/release/hwloc/v${HWLOC_VERSION::-2}/hwloc-${HWLOC_VERSION}.tar.gz
tar xf hwloc-${HWLOC_VERSION}.tar.gz && cd hwloc-${HWLOC_VERSION}
./configure
make -s
make install -s
cd /tmp
rm -rf hwloc-${HWLOC_VERSION}*

# Install AWS_OFI_NCCL
# https://github.com/aws/aws-ofi-nccl
echo ""
echo "Installing AWS_OFI_NCCL ..."
yum install autoconf automake libtool -y -q
cd /tmp
wget -q https://github.com/aws/aws-ofi-nccl/releases/download/v${AWS_OFI_NCCL_VERSION}-aws/aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}-aws.tar.gz
tar xf aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}-aws.tar.gz && cd ./aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}-aws
./autogen.sh
./configure --with-libfabric=/opt/amazon/efa/ --with-cuda=/usr/local/cuda/ --with-mpi=/opt/amazon/openmpi/
make -s
make install -s
cd /tmp
rm -rf aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}*

# Install NCCL
# https://github.com/NVIDIA/nccl
echo ""
echo "Installing NCCL ..."
cd /tmp
wget -q -O nccl.zip https://github.com/NVIDIA/nccl/archive/refs/tags/v${NCCL_VERSION}-1.zip
unzip -qq nccl.zip && cd nccl-${NCCL_VERSION}-1
make -j src.build -s
make pkg.redhat.build -s
rpm -ivh build/pkg/rpm/x86_64/*.rpm
cd /tmp
rm -rf nccl*

# Install NCCL tests
echo ""
echo "Installing NCCL tests ..."
git clone https://github.com/NVIDIA/nccl-tests.git /opt/nccl-tests
cd /opt/nccl-tests
make -j MPI=1 MPI_HOME=/opt/amazon/openmpi CUDA_HOME=/usr/local/cuda NCCL_HOME=/opt/nccl/build NVCC_GENCODE="-gencode=arch=compute_80,code=sm_80 -gencode=arch=compute_86,code=sm_86 -gencode=arch=compute_90,code=sm_90"

# Set up profile
echo ""
echo "Setting up profile ..."
echo 'export PATH=$PATH:/usr/local/bin' >> /etc/profile

# Update containerd config
# If the conainer runtime is not already configured in the AMI, uncomment the section below toconfigure containerd
#echo ""
#echo "Updating containerd config in bootstrap path /etc/eks ..."
#cd /tmp
#ls -alh /etc/eks/containerd
#mv -f /etc/eks/containerd/containerd-config.toml /etc/eks/containerd/containerd-config.toml-original
#cp -vf /tmp/containerd-config.toml /etc/eks/containerd/containerd-config.toml
#mv -f /etc/eks/containerd-config-nvidia.toml /etc/eks/containerd-config-nvidia.toml-original
#cp -vf /tmp/containerd-config.toml /etc/eks/containerd-config-nvidia.toml
#cp -vf /tmp/containerd-config.toml /etc/eks/containerd/containerd-config-2.toml
#cat /etc/eks/containerd/containerd-config.toml

echo ""
date
echo "Done executing install.sh"
echo ""

