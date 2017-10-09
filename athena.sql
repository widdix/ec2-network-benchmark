
# Delete existing table

DROP TABLE networkbenchmark;

# Create table

CREATE EXTERNAL TABLE networkbenchmark (
  `end` struct<
          `sum_sent`:struct<`bits_per_second`:double,`retransmits`:int>,
          `sum_received`:struct<`bits_per_second`:double,`retransmits`:int>
          > 
)
PARTITIONED BY (d string, r string, it string, t string) 
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
LOCATION 's3://ec2-network-benchmark-global-s3bucket-1ih4oztgq5iuh/';


# Load partiations from S3

MSCK REPAIR TABLE networkbenchmark;

# Query performance data
SELECT 
  "end"."sum_sent"."bits_per_second" AS sent_bits_per_second, 
  "end"."sum_received"."bits_per_second" AS received_bits_per_second, 
  r, 
  it 
FROM networkbenchmark;
