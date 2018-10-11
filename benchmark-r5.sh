#!/bin/bash -x

INSTANCE_TYPE_SERVER="c5.18xlarge"
SPOT_PRICE_SERVER="3.456"

# $1 = client instance type
function create {
  aws cloudformation create-stack --stack-name ec2-network-benchmark-${1//./-} --parameters ParameterKey=ParentVPCStack,ParameterValue=ec2-network-benchmark-vpc ParameterKey=ParentGlobalStack,ParameterValue=ec2-network-benchmark-global ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=SpotPriceClient,ParameterValue=$2 ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER ParameterKey=SpotPriceServer,ParameterValue=$SPOT_PRICE_SERVER --template-body file://benchmark.yaml
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

create r5.large 0
create r5.xlarge 0
create r5.2xlarge 0
create r5.4xlarge 0
create r5.12xlarge 0
create r5.24xlarge 0

wait_create_complete r5.large
wait_create_complete r5.xlarge
wait_create_complete r5.2xlarge
wait_create_complete r5.4xlarge
wait_create_complete r5.12xlarge
wait_create_complete r5.24xlarge

delete r5.large
delete r5.xlarge
delete r5.2xlarge
delete r5.4xlarge
delete r5.12xlarge
delete r5.24xlarge

wait_delete_complete r5.large
wait_delete_complete r5.xlarge
wait_delete_complete r5.2xlarge
wait_delete_complete r5.4xlarge
wait_delete_complete r5.12xlarge
wait_delete_complete r5.24xlarge

