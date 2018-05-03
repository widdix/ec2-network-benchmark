#!/bin/bash -x

. benchmark-cache.inc.sh

# Format
# <redis instance type>[:<client instance count>[:<test duration seconds]]
INSTANCE_BENCHMARKS=(
    cache.m4.large
    cache.m4.xlarge
    cache.m4.2xlarge
    cache.m4.4xlarge
    cache.m4.10xlarge
)

execute_test_plan ${INSTANCE_BENCHMARKS[@]}
