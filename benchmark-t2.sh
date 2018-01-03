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

create t2.nano 0
create t2.micro 0.0126
create t2.small 0.025
create t2.medium 0.05
create t2.large 0.1008
create t2.xlarge 0.2016
create t2.2xlarge 0.4032

wait_create_complete t2.nano
wait_create_complete t2.micro
wait_create_complete t2.small
wait_create_complete t2.medium
wait_create_complete t2.large
wait_create_complete t2.xlarge
wait_create_complete t2.2xlarge

delete t2.nano
delete t2.micro
delete t2.small
delete t2.medium
delete t2.large
delete t2.xlarge
delete t2.2xlarge

wait_delete_complete t2.nano
wait_delete_complete t2.micro
wait_delete_complete t2.small
wait_delete_complete t2.medium
wait_delete_complete t2.large
wait_delete_complete t2.xlarge
wait_delete_complete t2.2xlarge

