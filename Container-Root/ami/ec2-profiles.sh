#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

CMD="aws iam list-instance-profiles --query \"InstanceProfiles[*].{InstanceProfileId:InstanceProfileId,InstanceProfileName:InstanceProfileName,Arn:Arn,Role0:Roles[0].RoleName,Role1:Roles[1].RoleName}\" --output table"

echo "$CMD"

eval "$CMD"

