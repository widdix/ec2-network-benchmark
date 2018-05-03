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

**Example Results:**

| instancetype | dataSize | mbps_p90 | mbps_p70 | test_passes | cpuutilization_90 | enginecpuutilization_90 | cpuutilization_50 | enginecpuutilization_50 |
| ------------ | -------- | -------- | -------- | ----------- | ----------------- | ----------------------- | ----------------- | ----------------------- |
| `cache.r4.4xlarge`  | 100000 | 9211.309 | 9098.941  | 3 | 9.273073  | 49.221848 | 6.251554  | 46.502052 |
| `cache.r4.8xlarge`  | 100000 | 9106.479 | 8965.279  | 3 | 5.1063986 | 49.136944 | 4.6466618 | 40.50802  |
| `cache.m4.10xlarge` | 100000 | 8990.691 | 8957.348  | 2 | 2.3085928 | 39.05509  | 2.2267942 | 30.193382 |
| `cache.r4.2xlarge`  | 100000 | 7828.376 | 7587.0874 | 3 | 32.194942 | 59.450256 | 26.06959  | 50.664406 |
| `cache.r4.xlarge`   | 100000 | 6234.919 | 6155.1865 | 2 | 55.188168 | 61.926918 | 37.938736 | 59.221046 |
