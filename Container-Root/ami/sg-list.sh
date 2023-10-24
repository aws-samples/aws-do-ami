#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################


CMD="aws ec2 describe-security-groups --query \"SecurityGroups[*].{GroupId:GroupId,GroupName:GroupName,Description:Description,VpcId:VpcId}\" $filters --output table"

echo "$CMD"

eval "$CMD"

