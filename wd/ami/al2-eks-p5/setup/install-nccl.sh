#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

HWLOC_VERSION=$1
if [ "$HWLOC_VERSION" == "" ]; then
	HWLOC_VERSION=2.9.2
fi
BASE_HWLOC_VERSION=$(echo $HWLOC_VERSION | cut -d "." -f 1-2)

AWS_OFI_NCCL_VERSION=$2
if [ "$AWS_OFI_NCCL_VERSION" == "" ]; then
	AWS_OFI_NCCL_VERSION=1.7.0
fi

NCCL_VERSION=$3
if [ "$NCCL_VERSION" == "" ]; then
        NCCL_VERSION=master
fi

NCCL_TEST_VERSION=$4
if [ "$NCCL_TEST_VERSION" == "" ]; then
        NCCL_TEST_VERSION=master
fi

## Install hwloc
cd /tmp
wget https://download.open-mpi.org/release/hwloc/v${BASE_HWLOC_VERSION}/hwloc-${HWLOC_VERSION}.tar.gz
tar xf hwloc-${HWLOC_VERSION}.tar.gz && cd hwloc-${HWLOC_VERSION}
./configure
make
sudo make install

## Install AWS ofi-nccl
sudo yum install autoconf automake libtool -y
cd /tmp
 wget https://github.com/aws/aws-ofi-nccl/releases/download/v${AWS_OFI_NCCL_VERSION}-aws/aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}-aws.tar.gz
tar xf aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}-aws.tar.gz && cd ./aws-ofi-nccl-${AWS_OFI_NCCL_VERSION}-aws
./autogen.sh
./configure --with-libfabric=/opt/amazon/efa/ --with-cuda=/usr/local/cuda/ --with-mpi=/opt/amazon/openmpi/
make
sudo make install

## Install NCCL
cd ${HOME}
wget -O nccl.zip  https://github.com/NVIDIA/nccl/archive/refs/heads/${NCCL_VERSION}.zip
unzip -o nccl.zip && cd nccl-${NCCL_VERSION}
make -j src.build
make pkg.redhat.build
make install
whereis libnccl
#libnccl: /usr/local/lib/libnccl.so

## Setup NCCL tests
cd ${HOME}
wget -O nccl-test.zip https://github.com/NVIDIA/nccl-tests/archive/refs/heads/${NCCL_TEST_VERSION}.zip
unzip -o nccl-test.zip && cd nccl-tests-${NCCL_TEST_VERSION}
make MPI=1 NCCL_HOME=${HOME}/nccl-${NCCL_VERSION}/build MPI_HOME=/opt/amazon/openmpi/

# set up environment
export EFA_HOME=/opt/amazon/efa
export MPI_HOME=/opt/amazon/openmpi
export LD_LIBRARY_PATH=${EFA_HOME}/lib64:${MPI_HOME}/lib64:/usr/local/lib

echo "export EFA_HOME=/opt/amazon/efa" >> /etc/bashrc
echo "export MPI_HOME=/opt/amazon/openmpi" >> /etc/bashrc
echo "export LD_LIBRARY_PATH=${EFA_HOME}/lib64:${MPI_HOME}/lib64:/usr/local/lib" >> /etc/bashrc

# mpirun --allow-run-as-root -np 8 -bind-to none -map-by slot -x NCCL_DEBUG=INFO -x LD_LIBRARY_PATH -x PATH -x FI_EFA_USE_DEVICE_RDMA=1 -x FI_EFA_FORK_SAFE=1 -mca pml ob1 -mca btl ^openib ./build/all_reduce_perf -b 8 -e 2G -f 2 -t 1 -g 1 -c 1 -n 100
