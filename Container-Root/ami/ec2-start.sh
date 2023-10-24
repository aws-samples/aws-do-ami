#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

source ./ec2.conf

function usage(){
	echo ""
	echo "Usage: $0 <instnce_id>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Starting instance $1 ..."
	# Check if instance exists
	CMD="aws ec2 describe-instances --instance-ids $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws ec2 start-instances --instance-ids $1 > /dev/null"
		echo ""
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo "Instance $1 started."
		else
			echo "Failed to start instance $1"
		fi
	fi
	echo ""
fi

