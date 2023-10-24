#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

CMD="aws ec2 describe-instances --query \"Reservations[*].Instances[*].{InstanceId:InstanceId,Keypair:KeyName,InstanceType:InstanceType,ImageId:ImageId,PrivateIpAddress:PrivateIpAddress,AvailabilityZone:Placement.AvailabilityZone,SubnetId:SubnetId,VpcId:VpcId,Status:State.Name,PublicDnsName:PublicDnsName,Name:Tags[?Key=='Name']|[0].Value}\" $filters --output table"

eval "$CMD"
