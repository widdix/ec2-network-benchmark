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

create h1.2xlarge 0.611
create h1.4xlarge 1.222
create h1.8xlarge 2.444
create h1.16xlarge 4.888

wait_create_complete h1.2xlarge
wait_create_complete h1.4xlarge
wait_create_complete h1.8xlarge
wait_create_complete h1.16xlarge

delete h1.2xlarge
delete h1.4xlarge
delete h1.8xlarge
delete h1.16xlarge

wait_delete_complete h1.2xlarge
wait_delete_complete h1.4xlarge
wait_delete_complete h1.8xlarge
wait_delete_complete h1.16xlarge
