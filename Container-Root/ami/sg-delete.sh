#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################


function usage() {
	echo ""
	echo "Usage: $0 <security_group_id>"
	echo ""
}

if [ "$1" == "" ]; then
	usage
else
	echo ""
	echo "Deleting security group $1 ..."
	# Check if security group exists
	CMD="aws ec2 describe-security-groups --group-ids $1 > /dev/null"
	eval "$CMD"
	if [ "$?" == "0" ]; then
		CMD="aws ec2 delete-security-group --group-id $1"
		echo "$CMD"
		eval "$CMD"
		if [ "$?" == "0" ]; then
			echo "Deleted"
		else
			echo "Failed to delete"
		fi
	fi
	echo ""
fi
