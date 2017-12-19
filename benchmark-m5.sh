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

create m5.large
create m5.xlarge
create m5.2xlarge
create m5.4xlarge
create m5.12xlarge
create m5.24xlarge

wait_create_complete m5.large
wait_create_complete m5.xlarge
wait_create_complete m5.2xlarge
wait_create_complete m5.4xlarge
wait_create_complete m5.12xlarge
wait_create_complete m5.24xlarge

delete m5.large
delete m5.xlarge
delete m5.2xlarge
delete m5.4xlarge
delete m5.12xlarge
delete m5.24xlarge

wait_delete_complete m5.large
wait_delete_complete m5.xlarge
wait_delete_complete m5.2xlarge
wait_delete_complete m4.4xlarge
wait_delete_complete m5.4xlarge
wait_delete_complete m5.24xlarge
