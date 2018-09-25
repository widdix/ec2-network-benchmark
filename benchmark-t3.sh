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

create t3.nano 0
create t3.micro 0.0104
create t3.small 0.0228
create t3.medium 0.0456
create t3.large 0.0912
create t3.xlarge 0.1824
create t3.2xlarge 0.3648

wait_create_complete t3.nano
wait_create_complete t3.micro
wait_create_complete t3.small
wait_create_complete t3.medium
wait_create_complete t3.large
wait_create_complete t3.xlarge
wait_create_complete t3.2xlarge

delete t3.nano
delete t3.micro
delete t3.small
delete t3.medium
delete t3.large
delete t3.xlarge
delete t3.2xlarge

wait_delete_complete t3.nano
wait_delete_complete t3.micro
wait_delete_complete t3.small
wait_delete_complete t3.medium
wait_delete_complete t3.large
wait_delete_complete t3.xlarge
wait_delete_complete t3.2xlarge

