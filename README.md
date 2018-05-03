# EC2 Network Benchmark

All you need to run your own Network Benchmarks on EC2.

## Instructions

1. Create a VPC or VPC wrapper based on our [VPC templates](http://templates.cloudonaut.io/en/stable/vpc/).
1. Create a stack based on `global.yaml` which will create an S3 bucket to store the results of your network benchmarks.
1. Create a stack based on `benchmark.yaml` to run a network benchmark or use one of the `benchmark-*.sh` scripts to do so.

Create a stack based on `global-wrapper.yaml` if you want to run your network benchmark in multiple regions. Requires a stack based on `global.yaml` within another region.

- - -

# ec2-network-benchmark

## ElastiCache
_See scripts `benchmark-cache.{family}.sh`_
