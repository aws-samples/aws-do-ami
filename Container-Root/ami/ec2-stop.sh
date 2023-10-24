#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage(){
	echo ""
	echo "Usage: $0 <instnce_id>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Stopping instance $1 ..."
	# Check if instance exists
	CMD="aws ec2 describe-instances --instance-ids $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws ec2 stop-instances --instance-ids $1 > /dev/null"
		eval "$CMD"
		echo ""
		if [ "$?" == "0" ]; then
			echo "Instance $1 stopped."
		else
			echo "Failed to stop instance $1"
		fi
	fi
	echo ""
fi
