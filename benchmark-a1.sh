#!/bin/bash -x

INSTANCE_TYPE_SERVER="c5.18xlarge"
SPOT_PRICE_SERVER="3.456"

# $1 = client instance type
function create {
  aws cloudformation create-stack --stack-name ec2-network-benchmark-${1//./-} --parameters ParameterKey=ParentVPCStack,ParameterValue=vpc-2azs ParameterKey=ParentGlobalStack,ParameterValue=benchmark-global ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER ParameterKey=SpotPriceServer,ParameterValue=$SPOT_PRICE_SERVER --template-body file://benchmark.yaml
}

# $1 = client instance type
function wait_create_complete {
  aws cloudformation wait stack-create-complete --stack-name ec2-network-benchmark-${1//./-}
}

# $1 = client instance type
function delete {
  aws cloudformation delete-stack --stack-name ec2-network-benchmark-${1//./-}
}

# $1 = client instance type
function wait_delete_complete {
  aws cloudformation wait stack-delete-complete --stack-name ec2-network-benchmark-${1//./-}
}

create a1.medium
create a1.large
create a1.xlarge
create a1.2xlarge
create a1.4xlarge

wait_create_complete a1.medium
wait_create_complete a1.large
wait_create_complete a1.xlarge
wait_create_complete a1.2xlarge
wait_create_complete a1.4xlarge

delete a1.medium
delete a1.large
delete a1.xlarge
delete a1.2xlarge
delete a1.4xlarge

wait_delete_complete a1.medium
wait_delete_complete a1.large
wait_delete_complete a1.xlarge
wait_delete_complete a1.2xlarge
wait_delete_complete a1.4xlarge
