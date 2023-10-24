#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

# EC2 Instance Configuration
source wd/conf/ec2.conf

echo ""

if [ "$EC2_INSTANCE_NAME" == "" ]; then
	echo "Please configure all settings in the EC2 Instance Configuration wd/conf/ec2.conf"
	echo "Then run $0 again to launch the instance"
else
	echo "Launching instance $EC2_INSTANCE_NAME ..."
	CMD="aws ec2 run-instances --image-id $EC2_IMAGE_ID --block-device-mappings \"DeviceName=/dev/xvda,Ebs={DeleteOnTermination=true,VolumeSize=$EC2_VOLUME_SIZE_GB,VolumeType=gp3,Encrypted=true}\" --instance-type $EC2_INSTANCE_TYPE --iam-instance-profile \"Name=$EC2_INSTANCE_PROFILE_NAME\" --network-interfaces \"AssociatePublicIpAddress=$EC2_ASSIGN_PUBLIC_IP,DeviceIndex=0,Groups=$EC2_SG_ID,SubnetId=$EC2_SUBNET_ID\" --tag-specifications \"ResourceType=instance,Tags=[{Key=Name,Value=$EC2_INSTANCE_NAME}]\" --key-name $EC2_KEY_NAME"
	echo "$CMD"
	eval "$CMD"
fi

echo ""
