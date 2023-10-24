#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage(){
	echo ""
	echo "Usage: $0 <vpc_id>"
	echo ""
}

if [[ "$1" == "" || "$1" == "-h" || "$1" == "--help" ]]; then
	usage
else
	current_vpc=$1 
	filters="--filters Name=vpc-id,Values=${current_vpc}"
	CMD="aws ec2 describe-subnets ${filters} --query \"Subnets[*].{Name:Tags[?Key=='Name']|[0].Value,CidrBlock:CidrBlock,AvailabilityZone:AvailabilityZone,IPs:AvailableIpAddressCount,Public:MapPublicIpOnLaunch,SubnetId:SubnetId,VpcId:VpcId}\" --output table"
        echo "$CMD"
	eval "$CMD"
fi

