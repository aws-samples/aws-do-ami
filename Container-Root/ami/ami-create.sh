#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage(){
	echo ""
	echo "Usage: $0 [DIR_NAME]"
	echo ""
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	usage
else
	DIR_NAME=al2-gromacs
	if [ ! "$1" == "" ]; then
		DIR_NAME=$1
	fi

	OS_TYPE=amzn2

	pushd /wd/ami/$DIR_NAME

	if [ -f ./vars.json ]; then
		VARS_OPT="-var-file vars.json"
	fi
	CMD="packer build $VARS_OPT packer.json"

	echo "$CMD"

	eval "$CMD"

	popd
fi

