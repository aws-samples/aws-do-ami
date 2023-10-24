#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

aws cloudformation list-stacks --stack-status-filter "CREATE_COMPLETE" --query "StackSummaries[].StackName" 


