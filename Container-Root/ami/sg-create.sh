#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

function usage() {
	echo ""
	echo "Usage: $0 <security_group_name> [vpc_id] [security_group_desc]"
	echo ""
	echo "    security_group_name - The name of the security group to create (required)"
	echo "    vpc_id              - The vpc_id where to create the security group (required)."
	echo "                          If not specified, will try to retrieve from ec2.conf file's"
	echo "                          current_vpc or EC2_SUBNET_ID setting."
	echo "    security_group_desc - Description of the security group (optional)"
	echo ""
}

if [ "$2" == "" ]; then
        echo ""
	echo "Please specify security_group_name and vpc_id"
        echo ""
	usage
	exit 1
fi

DESCRIPTION="$3"
if [ "$DESCRIPTION" == "" ]; then
	DESCRIPTION="Security group $1 created by aws-do-cli"
fi

CMD="aws ec2 create-security-group --group-name \"$1\" --description \"$DESCRIPTION\" --vpc-id \"$VPC_ID\" --query GroupId --output text"
echo "$CMD"
GROUP_ID=$(eval "$CMD")

# Add rule to allow ssh from current host if public ip is assigned
if [ "$EC2_ASSIGN_PUBLIC_IP" == "true" ]; then
	echo ""
	echo "Adding ssh rule to security group $GROUP_ID ..."
	IP=$(curl https://checkip.amazonaws.com)
	echo "Allow TCP to port 22 from $IP "
	CMD="aws ec2 authorize-security-group-ingress --group-id $GROUP_ID --protocol tcp --port 22 --cidr ${IP}/32"
	echo "$CMD"
	eval "$CMD"
fi

echo ""
echo "Created SecurityGroup ID: $GROUP_ID"
echo ""
