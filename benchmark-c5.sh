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

create c5.large
create c5.xlarge
create c5.2xlarge
create c5.4xlarge
create c5.9xlarge
create c5.18xlarge

wait_create_complete c5.large
wait_create_complete c5.xlarge
wait_create_complete c5.2xlarge
wait_create_complete c5.4xlarge
wait_create_complete c5.9xlarge
wait_create_complete c5.18xlarge

delete c5.large
delete c5.xlarge
delete c5.2xlarge
delete c5.4xlarge
delete c5.9xlarge
delete c5.18xlarge

wait_delete_complete c5.large
wait_delete_complete c5.xlarge
wait_delete_complete c5.2xlarge
wait_delete_complete c5.4xlarge
wait_delete_complete c5.9xlarge
wait_delete_complete c5.18xlarge

