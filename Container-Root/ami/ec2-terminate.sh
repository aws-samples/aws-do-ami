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
	echo "Terminating instance $1 ..."
	# Check if instance exists
	CMD="aws ec2 describe-instances --instance-ids $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		echo ""
		CMD="aws ec2 terminate-instances --instance-ids $1 > /dev/null"
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo "Instance $1 terminated."
		else
			echo "Failed to terminate instance $1"
		fi
	fi
	echo ""
fi
