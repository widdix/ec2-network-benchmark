#!/bin/bash -x

INSTANCE_TYPE_SERVER=m5.24xlarge

# $1 = client instance type
function create {
  aws cloudformation create-stack --stack-name ec2-network-benchmark-${1//./-} --parameters ParameterKey=ParentVPCStack,ParameterValue=ec2-network-benchmark-vpc ParameterKey=ParentGlobalStack,ParameterValue=ec2-network-benchmark-global ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER --template-body file://benchmark.yaml
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

create d2.xlarge
create d2.2xlarge
create d2.4xlarge
create d2.8xlarge

wait_create_complete d2.xlarge
wait_create_complete d2.2xlarge
wait_create_complete d2.4xlarge
wait_create_complete d2.8xlarge

delete d2.xlarge
delete d2.2xlarge
delete d2.4xlarge
delete d2.8xlarge

wait_delete_complete d2.xlarge
wait_delete_complete d2.2xlarge
wait_delete_complete d2.4xlarge
wait_delete_complete d2.8xlarge
