#!/bin/bash -x

. benchmark-cache.inc.sh

# Format
# <redis instance type>[:<client instance count>[:<test duration seconds]]
INSTANCE_BENCHMARKS=(
    cache.m3.medium
    cache.m3.large
    cache.m3.xlarge
    cache.m3.2xlarge
)

execute_test_plan ${INSTANCE_BENCHMARKS[@]}
