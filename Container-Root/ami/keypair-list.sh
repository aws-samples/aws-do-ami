#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

CMD="aws ec2 describe-key-pairs --query \"KeyPairs[*].{KeyPairId:KeyPairId,KeyName:KeyName,KeyType:KeyType}\" --output table"

echo "$CMD"
eval "$CMD"
