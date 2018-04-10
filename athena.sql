
# Delete existing table

DROP TABLE networkbenchmark;

# Create table

CREATE EXTERNAL TABLE networkbenchmark (
  `intervals` array<struct<
    `sum`:struct<`bits_per_second`:decimal(38,6)>
  >>,
  instanceType string,
  region string
)
PARTITIONED BY (d date)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://ec2-network-benchmark-global-s3bucket-1e2fy8tntcdz5/v2/';


# Load partiations from S3

MSCK REPAIR TABLE networkbenchmark;

# results in Gbit/s
# counter = more or less minute of the benchmark
# cardinality(intervals) => filter results with less than X intervals

SELECT 
  (min(interval.sum.bits_per_second)/1000000000) AS min,
  (max(interval.sum.bits_per_second)/1000000000) AS max,
  (avg(interval.sum.bits_per_second)/1000000000) AS avg,
  (stddev(interval.sum.bits_per_second)/1000000000) AS stddev,
  region, 
  instancetype 
FROM networkbenchmark CROSS JOIN UNNEST(intervals) WITH ORDINALITY AS t(interval, counter)
WHERE d >= from_iso8601_date('2018-04-01') AND cardinality(intervals) >= 25 AND counter > 10 AND counter < 60
GROUP BY region, instancetype 
ORDER BY region, instancetype
