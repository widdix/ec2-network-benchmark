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

### Querying Results
#### Highest Bandwidth Test Configurations
If you have run tests with various data sizes (`RedisDataSize` parameter in
[benchmark-elasticache-redis.yaml](benchmark-elasticache-redis.yaml)), the
following query will show you under which size data you'll get what level
of bandwidth performance from. Ideally, you should profile what your data
sizes are in your target environment, and what traffic level they tend to
receive, and pick one-or-more data size parameters to exercise.

```sql
SELECT
    instancetype,
    dataSize,
    (avg(networkbytesout.p90)/60/1024/1024*8) AS mbps_p90,
    (avg(networkbytesout.p70)/60/1024/1024*8) AS mbps_p70,
    count(distinct benchmarkId) as test_passes,
    avg(cpuutilization.p90) AS cpuutilization_90,
    avg(enginecpuutilization.p90) AS enginecpuutilization_90,
    avg(cpuutilization.p50) AS cpuutilization_50,
    avg(enginecpuutilization.p50) AS enginecpuutilization_50
FROM cachenetworkbenchmark
WHERE d >= from_iso8601_date('2018-05-01')
GROUP BY region, instancetype, dataSize
ORDER BY mbps_p90 DESC, region, instancetype, dataSize
```
