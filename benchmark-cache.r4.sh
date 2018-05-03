#!/bin/bash -x

. benchmark-cache.inc.sh

# Format
# <redis instance type>[:<client instance count>[:<test duration seconds]]
INSTANCE_BENCHMARKS=(
    cache.r4.large
    cache.r4.xlarge
    cache.r4.2xlarge
    cache.r4.4xlarge
    cache.r4.8xlarge
    cache.r4.16xlarge
)

execute_test_plan ${INSTANCE_BENCHMARKS[@]}
