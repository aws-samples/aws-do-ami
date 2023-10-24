#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

EFA_VERSION=$1
if [ "$EFA_VERSION" == "" ]; then
	EFA_VERSION=1.26.0
fi

curl -O https://efa-installer.amazonaws.com/aws-efa-installer-${EFA_VERSION}.tar.gz --output-dir /tmp
tar -xf /tmp/aws-efa-installer-${EFA_VERSION}.tar.gz -C /tmp
cd /tmp/aws-efa-installer
./efa_installer.sh -y -g
#/opt/amazon/efa/bin/fi_info -p efa
/opt/amazon/efa/bin/fi_info

