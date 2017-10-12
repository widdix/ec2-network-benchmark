#!/bin/bash -ex

INSTANCE_TYPE_SERVER=m4.16xlarge

# $1 = client instance type
function create {
  aws cloudformation create-stack --stack-name ec2-network-benchmark-${1//./-} --parameters ParameterKey=ParentVPCStack,ParameterValue=ec2-network-benchmark-vpc ParameterKey=ParentGlobalStack,ParameterValue=ec2-network-benchmark-global ParameterKey=InstanceTypeClient,ParameterValue=$1 ParameterKey=InstanceTypeServer,ParameterValue=$INSTANCE_TYPE_SERVER --template-body file://benchmark.yaml
}

# $1 = client instance type
function wait_create_complete {
  aws cloudformation wait stack-create-complete --stack-name ec2-network-benchmark-${1//./-}
  aws cloudformation delete-stack --stack-name ec2-network-benchmark-${1//./-} 
}

# $1 = client instance type
function delete {
  aws cloudformation wait stack-create-complete --stack-name ec2-network-benchmark-${1//./-}
  aws cloudformation delete-stack --stack-name ec2-network-benchmark-${1//./-} 
}

# $1 = client instance type
function wait_delete_complete {
  aws cloudformation wait stack-delete-complete --stack-name ec2-network-benchmark-${1//./-}
  aws cloudformation delete-stack --stack-name ec2-network-benchmark-${1//./-} 
}

# t2

create t2.nano
create t2.micro
create t2.small
create t2.medium
create t2.large

wait_create_complete t2.nano
wait_create_complete t2.micro
wait_create_complete t2.small
wait_create_complete t2.medium
wait_create_complete t2.large

delete t2.nano
delete t2.micro
delete t2.small
delete t2.medium
delete t2.large

wait_delete_complete t2.nano
wait_delete_complete t2.micro
wait_delete_complete t2.small
wait_delete_complete t2.medium
wait_delete_complete t2.large

create t2.2xlarge
wait_create_complete t2.2xlarge
delete t2.2xlarge
wait_delete_complete t2.2xlarge

# m4

create m4.large
create m4.xlarge
create m4.2xlarge
create m4.2xlarge
create m4.10xlarge

wait_create_complete m4.large
wait_create_complete m4.xlarge
wait_create_complete m4.2xlarge
wait_create_complete m4.2xlarge
wait_create_complete m4.10xlarge

delete m4.large
delete m4.xlarge
delete m4.2xlarge
delete m4.2xlarge
delete m4.10xlarge

wait_delete_complete m4.large
wait_delete_complete m4.xlarge
wait_delete_complete m4.2xlarge
wait_delete_complete m4.2xlarge
wait_delete_complete m4.10xlarge

create m4.16xlarge
wait_create_complete m4.16xlarge
delete m4.16xlarge
wait_delete_complete m4.16xlarge

# m3
create m3.medium
create m3.large
create m3.xlarge
create m3.2xlarge

wait_create_complete m3.medium
wait_create_complete m3.large
wait_create_complete m3.xlarge
wait_create_complete m3.2xlarge

delete m3.medium
delete m3.large
delete m3.xlarge
delete m3.2xlarge

wait_delete_complete m3.medium
wait_delete_complete m3.large
wait_delete_complete m3.xlarge
wait_delete_complete m3.2xlarge
