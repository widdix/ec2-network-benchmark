#!/bin/bash -x

. benchmark-cache.inc.sh

# Format
# <redis instance type>[:<client instance count>[:<test duration seconds]]
INSTANCE_BENCHMARKS=(
    cache.r3.large
    cache.r3.xlarge
    cache.r3.2xlarge
    cache.r3.4xlarge
    cache.r3.8xlarge
)

execute_test_plan ${INSTANCE_BENCHMARKS[@]}
