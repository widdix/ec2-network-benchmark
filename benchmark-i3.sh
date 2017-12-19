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

create i3.large
create i3.xlarge
create i3.2xlarge
create i3.4xlarge
create i3.8xlarge
create i3.16xlarge

wait_create_complete i3.large
wait_create_complete i3.xlarge
wait_create_complete i3.2xlarge
wait_create_complete i3.4xlarge
wait_create_complete i3.8xlarge
wait_create_complete i3.16xlarge

delete i3.large
delete i3.xlarge
delete i3.2xlarge
delete i3.4xlarge
delete i3.8xlarge
delete i3.16xlarge

wait_delete_complete i3.large
wait_delete_complete i3.xlarge
wait_delete_complete i3.2xlarge
wait_delete_complete i3.4xlarge
wait_delete_complete i3.8xlarge
wait_delete_complete i3.16xlarge
