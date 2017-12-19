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

create m4.large
create m4.xlarge
create m4.2xlarge
create m4.4xlarge
create m4.8xlarge

wait_create_complete m4.large
wait_create_complete m4.xlarge
wait_create_complete m4.2xlarge
wait_create_complete m4.4xlarge
wait_create_complete m4.8xlarge

delete m4.large
delete m4.xlarge
delete m4.2xlarge
delete m4.4xlarge
delete m4.8xlarge

wait_delete_complete m4.large
wait_delete_complete m4.xlarge
wait_delete_complete m4.2xlarge
wait_delete_complete m4.4xlarge
wait_delete_complete m4.8xlarge

