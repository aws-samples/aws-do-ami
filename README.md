<img alt="aws-do-ami" src="./aws-do-ami.png" width="25%" align="right" />

# AWS do AMI (aws-do-ami) - <br/>Create and manage your Amazon Machine Images (AMI) using the [do-framework](https://bit.ly/do-framework) 

## Overview
[Amazon Machine Images (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) are machine images that contain the information required to launch [EC2 instances](https://aws.amazon.com/ec2/). This project builds a container that has [HashiCorp Packer](https://www.packer.io/) and utility scripts that help with building and management of Amazon Machine Images. Example image definitions are provided as well. The goal of this project is to make building and management of Amazon Machine Images easy by following the principles of the [do-framework](https://bit.ly/do-framework).

## Prerequisites

* [Git](https://git-scm.com/downloads) - needed to clone this project
* [Docker](https://docs.docker.com/get-docker/) - needed to build and run the project
* [AWS CLI Credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html) - needed to access AWS APIs

## Build

Execute `./build.sh` to build the `aws-do-ami` container image.

## Run

Execute `./run.sh` to start the `aws-do-ami` container.

## Status

The `./status.sh` script shows the current state of the `aws-do-ami` container.

## Exec

Run the `./exec.sh` script to open a shell in the `aws-do-ami` container. All tools, the `packer` cli, and utility scripts are available in the /ami directory.

### Utility scripts

* `ami-create.sh [name]` - create an ami from the definition in folder `wd/ami/<name>`
* `ami-delete.sh <AMI_ID>` - deregister specified ami from account 
* `ami-dir.sh` - list local ami definitions 
* `ami-list.sh` - list ami's owned by the current AWS account 
* `aws-config.sh` - configure aws client
* `ec2-launch.sh` - launch an EC2 instance from ami as configured in `wd/conf/ec2.conf`
* `ec2-list.sh` - list all EC2 instances in the configured account and region
* `ec2-profiles.sh` - list available instance profiles
* `ec2-start.sh <instance_id>` - start a stopped EC2 instance
* `ec2-stop.sh <instance_id>` - stop a running EC2 instance
* `ec2-terminate.sh <instance_id>` - terminate the specified EC2 instance
* `keypair-create.sh [KEYPAIR_NAME]` - create ssh key pair with specified name
* `keypair-delete.sh [KAYPAIR_NAME]` - delete the specified key pair
* `keypair-list.sh` - list available ssh key pairs
* `sg-create.sh` - create a security group and allow SSH access from the current IP address
* `sg-delete.sh <sg_id>` - delete the specified security group
* `sg-list.sh` - list available security groups
* `stack-delete.sh <stack_name>` - delete cloud formation stack by name
* `stack-list.sh` - list completed cloud formation stacks
* `vpc-list.sh` - list current VPCs in the region
* `vpc-subnets.sh <vpc_id>` - list subnets belonging to the specified vpc

## Stop

Execute the `./stop.sh` script to stop and remove the `aws-do-ami` container.

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

## References
* [Docker](https://docker.com)
* [do-framework](https://bit.ly/do-framework)
* [Amazon Machine Images](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
* [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/)

