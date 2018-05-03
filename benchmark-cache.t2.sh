#!/bin/bash -x

. benchmark-cache.inc.sh

# Format
# <redis instance type>[:<client instance count>[:<test duration seconds]]
INSTANCE_BENCHMARKS=(
    cache.t2.micro
    cache.t2.small
    cache.t2.medium
)

execute_test_plan ${INSTANCE_BENCHMARKS[@]}
