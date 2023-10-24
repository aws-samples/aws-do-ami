#!/bin/bash

######################################################################
# Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved. #
# SPDX-License-Identifier: MIT-0                                     #
######################################################################

if [ "${DEBUG}" == "true" ]; then
        set -x
fi

print_help() {
	echo ""
	echo "Usage: $0"
	echo ""
	echo "   This script assists with logging in to a private container registry."
	echo "   By default we use Amazon ECR, however the script can be extended to support other registries as needed."
	echo "   In order to login successfully, the environment in which this script is running, must be configured"
	echo "   with an IAM role allowing access to ECR in the target AWS account."
	echo ""
}

if [ "$1" == "" ]; then

    	. ./.env

	# Login to container registry
        echo "Logging in to $REGISTRY_TYPE $REGISTRY ..."
        CMD="aws ecr get-login-password | docker login --username AWS --password-stdin $REGISTRY"
        if [ "${VERBOSE}" == "true" ]; then
            echo "${CMD}"
        fi
        eval "${CMD}"
else
	print_help
fi

if [ "${DEBUG}" == "true" ]; then
        set +x
fi
