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

create m4.large 0.111
create m4.xlarge 0.222
create m4.2xlarge 0.444
create m4.4xlarge 0.888
create m4.10xlarge 2.22
create m4.16xlarge 3.552

wait_create_complete m4.large
wait_create_complete m4.xlarge
wait_create_complete m4.2xlarge
wait_create_complete m4.4xlarge
wait_create_complete m4.10xlarge
wait_create_complete m4.16xlarge

delete m4.large
delete m4.xlarge
delete m4.2xlarge
delete m4.4xlarge
delete m4.10xlarge
delete m4.16xlarge

wait_delete_complete m4.large
wait_delete_complete m4.xlarge
wait_delete_complete m4.2xlarge
wait_delete_complete m4.4xlarge
wait_delete_complete m4.10xlarge
wait_delete_complete m4.16xlarge

