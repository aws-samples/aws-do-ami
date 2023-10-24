#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage(){
	echo ""
	echo "Usage: $0 [KEYPAIR_NAME]"
	echo ""
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	usage
else
	KEYPAIR_NAME=pcluster
	if [ ! "$1" == "" ]; then
		KEYPAIR_NAME=$1
	fi
	echo ""
	echo "Creating keypair $KEYPAIR_NAME ..."
	CMD="aws ec2 create-key-pair --key-name $KEYPAIR_NAME --query 'KeyMaterial' --output text > /wd/ssh/${KEYPAIR_NAME}.pem"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		echo ""
		cat /wd/ssh/${KEYPAIR_NAME}.pem
		echo ""
		echo "Key file saved in: /wd/ssh/${KEYPAIR_NAME}.pem"
		echo ""
	fi
fi
