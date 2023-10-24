#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage(){
	echo ""
	echo "Usage: $0 <STACK_NAME>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	STACK_NAME=$1
	aws cloudformation delete-stack --stack-name $STACK_NAME
fi

