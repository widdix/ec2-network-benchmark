
# Delete existing table

DROP TABLE IF EXISTS cachenetworkbenchmark;

# Create table

CREATE EXTERNAL TABLE IF NOT EXISTS cachenetworkbenchmark (
  benchmarkId string,
  CPUUtilization struct<p50:float,
                   p70:float,
                   p90:float,
                   p95:float,
                   p99:float
                  >,
  dataSize int,
  EngineCPUUtilization struct<p50:float,
                   p70:float,
                   p90:float,
                   p95:float,
                   p99:float
                  >,
  instanceType string,
  instanceTypeClient string,
  NetworkBytesOut struct<p50:float,
                   p70:float,
                   p90:float,
                   p95:float,
                   p99:float
                  >,
  region string
)
PARTITIONED BY (d date)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES (
  'serialization.format' = '1'
)
LOCATION 's3://ec2-network-benchmark2-global-s3bucket-1ul0glc1xwy4l/v2-cache/';


# Load partiations from S3

MSCK REPAIR TABLE cachenetworkbenchmark;

# results in mbit/s
# Takes Bytes per minute to gbit/s
SELECT
  instancetype,
  dataSize,
  (avg(networkbytesout.p90)/60/1024/1024*8) AS mbps_p90,
  avg(cpuutilization.p90) AS cpuutilization_90,
  avg(enginecpuutilization.p90) AS enginecpuutilization_90,
  count(distinct benchmarkId) as test_passes
FROM cachenetworkbenchmark
WHERE d >= from_iso8601_date('2018-04-01')
GROUP BY region, instancetype, dataSize
ORDER BY region, instancetype;
