#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage(){
	echo ""
	echo "Usage: $0 <image-id>"
	echo ""
}

if [[ "$1" == "" || "$1" == "-h" || "$1" == "--help" ]]; then
	usage
else
	aws ec2 deregister-image --image-id $1
fi

