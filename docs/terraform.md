<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| burst\_balance\_threshold | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. | `string` | `20` | no |
| cpu\_credit\_balance\_threshold | The minimum number of CPU credits (t2 instances only) available. | `string` | `20` | no |
| cpu\_utilization\_threshold | The maximum percentage of CPU utilization. | `string` | `80` | no |
| db\_cluster\_event\_categories | For a cluster, subcribe to these event categories. | `list(string)` | <pre>[<br>  "failover"<br>]</pre> | no |
| db\_cluster\_id | The cluster ID of the RDS database instance that you want to monitor. | `string` | `""` | no |
| db\_event\_subscription\_prefix\_name | n/a | `string` | `"rds-event-sub"` | no |
| db\_instance\_event\_categories | For an instance, subscribe to these event categoires. | `list(string)` | <pre>[<br>  "failover",<br>  "failure",<br>  "low storage",<br>  "maintenance",<br>  "notification",<br>  "recovery"<br>]</pre> | no |
| db\_instance\_id | The instance ID of the RDS database instance that you want to monitor. | `string` | `""` | no |
| disk\_queue\_depth\_threshold | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. | `string` | `64` | no |
| free\_storage\_space\_threshold | The minimum amount of available storage space in Byte. | `string` | `2000000000` | no |
| freeable\_memory\_threshold | The minimum amount of available random access memory in Byte. | `string` | `64000000` | no |
| sns\_topic\_arn | SNS topic ARN for to send RDS alerts to. | `string` | n/a | yes |
| swap\_usage\_threshold | The maximum amount of swap space used on the DB instance in Byte. | `string` | `256000000` | no |

## Outputs

No output.

<!-- markdownlint-restore -->
