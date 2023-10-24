#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

aws ec2 describe-images --owners self --query "Images[*].{ImageId:ImageId, Name:Name, Tags:Tags}" --output table

