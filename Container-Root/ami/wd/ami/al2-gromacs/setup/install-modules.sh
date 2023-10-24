#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

set -e

MODULES_PATH="/usr/share/Modules/modulefiles"

MODULES_VERSION="4.7.1"

MODULES_INSTALL_PATH="/usr/share/Modules"

yum install -y \
    gcc \
    gcc-c++ \
    gcc-gfortran \
    gzip \
    make \
    man \
    man-pages \
    procps \
    tar \
    tcl \
    tcl-devel \
    wget


# Create build directory in /tmp
WORK_DIR=$(mktemp -d /tmp/modules.XXXXXXXXX)
cd ${WORK_DIR}

# Saving current modules
if [ -f ${MODULES_PATH}/../init/.modulespath ]; then
    cp ${MODULES_PATH}/../init/.modulespath ${WORK_DIR}/
fi


# Download modules
curl -LOJ https://github.com/cea-hpc/modules/releases/download/v${MODULES_VERSION}/modules-${MODULES_VERSION}.tar.gz
tar -xvzf modules-${MODULES_VERSION}.tar.gz
cd modules-${MODULES_VERSION}

# Install Environment modules
./configure --prefix=${MODULES_INSTALL_PATH} \
    --modulefilesdir=${MODULES_PATH} \
    --enable-modulespath
make
make install

# Restore modules
if [ -f ${WORK_DIR}/.modulespath ]; then
    cp ${WORK_DIR}/.modulespath ${MODULES_PATH}/../init/.modulespath
fi

# Add modules to environment
if [ ! -f /etc/profile.d/modules.sh ]; then
    ln -s ${MODULES_PATH}/../init/profile.sh /etc/profile.d/modules.sh
fi


# Delete work_dir
cd
rm -rf ${WORK_DIR}
