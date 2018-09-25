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

create z1d.large 0.208
create z1d.xlarge 0.416
create z1d.2xlarge 0.832
create z1d.3xlarge 1.248
create z1d.6xlarge 2.496
create z1d.12xlarge 4.992

wait_create_complete z1d.large
wait_create_complete z1d.xlarge
wait_create_complete z1d.2xlarge
wait_create_complete z1d.3xlarge
wait_create_complete z1d.6xlarge
wait_create_complete z1d.12xlarge

delete z1d.large
delete z1d.xlarge
delete z1d.2xlarge
delete z1d.3xlarge
delete z1d.6xlarge
delete z1d.12xlarge

wait_delete_complete z1d.large
wait_delete_complete z1d.xlarge
wait_delete_complete z1d.2xlarge
wait_delete_complete z1d.3xlarge
wait_delete_complete z1d.6xlarge
wait_delete_complete z1d.12xlarge

