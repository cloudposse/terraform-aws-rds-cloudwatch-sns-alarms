## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | List of attributes to add to label. | list | `<list>` | no |
| burst_balance_threshold | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. | string | `20` | no |
| cpu_credit_balance_threshold | The minimum number of CPU credits (t2 instances only) available. | string | `20` | no |
| cpu_utilization_threshold | The maximum percentage of CPU utilization. | string | `80` | no |
| db_instance_id | The instance ID of the RDS database instance that you want to monitor. | string | - | yes |
| delimiter | The delimiter to be used in labels. | string | `-` | no |
| disk_queue_depth_threshold | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. | string | `64` | no |
| free_storage_space_threshold | The minimum amount of available storage space in Byte. | string | `2000000000` | no |
| freeable_memory_threshold | The minimum amount of available random access memory in Byte. | string | `64000000` | no |
| name | Name (unique identifier for app or service) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| swap_usage_threshold | The maximum amount of swap space used on the DB instance in Byte. | string | `256000000` | no |
| tags | Map of key-value pairs to use for tags. | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| sns_topic_arn | The ARN of the SNS topic |

