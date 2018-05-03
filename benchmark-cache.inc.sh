#!/bin/bash -x

INSTANCE_TYPE_CLIENT="c5.18xlarge"
SPOT_PRICE_CLIENT="3.456"
STACK_PREFIX=ec2-network-benchmark-
BASIC_TEST_DURATION=300

# $1 = redis instance type
# $2 = number of client instances
# $3 = optional test duration
function create {
  local instance_count=${2:-1}
  local test_duration=${3:-${BASIC_TEST_DURATION}}

  aws cloudformation create-stack \
      --stack-name ${STACK_PREFIX}${1//./-} \
      --parameters \
        ParameterKey=BenchmarkId,ParameterValue=$(uuidgen) \
        ParameterKey=InstanceCountClient,ParameterValue=$instance_count \
        ParameterKey=InstanceTypeClient,ParameterValue=$INSTANCE_TYPE_CLIENT \
        ParameterKey=ParentGlobalStack,ParameterValue=${STACK_PREFIX}global \
        ParameterKey=ParentVPCStack,ParameterValue=${STACK_PREFIX}vpc \
        ParameterKey=RedisInstanceType,ParameterValue=$1 \
        ParameterKey=SpotPriceClient,ParameterValue=$SPOT_PRICE_CLIENT \
        ParameterKey=TestDuration,ParameterValue=$test_duration \
      --template-body file://benchmark-elasticache-redis.yaml
}

# $1 = client instance type
function wait_create_complete {
  aws cloudformation wait stack-create-complete --stack-name ${STACK_PREFIX}${1//./-}
}

# $1 = client instance type
function delete {
  aws cloudformation delete-stack --stack-name ${STACK_PREFIX}${1//./-}
}

# $1 = client instance type
function wait_delete_complete {
  aws cloudformation wait stack-delete-complete --stack-name ${STACK_PREFIX}${1//./-}
}

# $1 = benchmark function to call with an INSTANCE_BENCHMARKS specification
# $@ = INSTANCE_BENCHMARKS specification
function loop_through_benchmarks {
    local loop_call=$1
    shift
    local loop_spec=( $@ )
    local call_args=
    for loop_arguments in ${loop_spec[@]}
    do
        call_args=$(tr ':' ' ' <<<${loop_arguments})
        $loop_call $call_args
    done
}

# $@ = INSTANCE_BENCHMARKS specification
function execute_test_plan {
    for call_command in \
        create \
        wait_create_complete \
        delete \
        wait_delete_complete
    do
        loop_through_benchmarks \
            $call_command \
            $@
    done
}
