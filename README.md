# terraform-aws-rds-alerts

Create a set of sane RDS CloudWatch alerts for monitoring the health of an RDS instance.

| area    | metric           | comparison operator  | threshold | rationale                                                                                                                                                                                              |
|---------|------------------|----------------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Storage | BurstBalance     | `<`                  | 20 %      | 20 % of credits allow you to burst for a few minutes which gives you enough time to a) fix the inefficiency, b) add capacity or c) switch to io1 storage type.                                         |
| Storage | DiskQueueDepth   | `>`                  | 64        | This number is calculated from our experience with RDS workloads.                                                                                                                                      |
| Storage | FreeStorageSpace | `<`                  | 2 GB      | 2 GB usually provides enough time to a) fix why so much space is consumed or b) add capacity. You can also modify this value to 10% of your database capacity.                                         |
| CPU     | CPUUtilization   | `>`                  | 80 %      | Queuing theory tells us the latency increases exponentially with utilization. In practice, we see higher latency when utilization exceeds 80% and unacceptable high latency with utilization above 90% |
| CPU     | CPUCreditBalance | `<`                  | 20        | One credit equals 1 minute of 100% usage of a vCPU. 20 credits should give you enough time to a) fix the inefficiency, b) add capacity or c) don't use t2 type.                                        |
| Memory  | FreeableMemory   | `<`                  | 64 MB     | This number is calculated from our experience with RDS workloads.                                                                                                                                      |
| Memory  | SwapUsage        | `>`                  | 256 MB    | Sometimes you can not entirely avoid swapping. But once the database accesses paged memory, it will slow down.                                                                                         |

## Example

```hcl
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier_prefix    = "rds-server-example"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  apply_immediately = "true"
  skip_final_snapshot = "true"
}

module "rds_alarms" {
  source = "github::https://github.com/bitflight-public/terraform-aws-rds-alerts.git?ref=master"
  db_instance_id = "${aws_db_instance.default.id}"
}
```

## Variables
| Name                         | Description                                                                              | Required |
|------------------------------|------------------------------------------------------------------------------------------|----------|
| db_instance_id               | The instance ID of the RDS database instance that you want to monitor.               		| Yes 		 |
| burst_balance_threshold      | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. 		| No       |
| cpu_utilization_threshold    | The maximum percentage of CPU utilization.                            										| No       |
| cpu_credit_balance_threshold | The minimum number of CPU credits (t2 instances only) available. 												| No       |
| disk_queue_depth_threshold   | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. 	| No       |
| freeable_memory_threshold    | The minimum amount of available random access memory in Byte. 														| No       |
| free_storage_space_threshold | The minimum amount of available storage space in Byte. 																	| No       |
| swap_usage_threshold         | The maximum amount of swap space used on the DB instance in Byte. 												| No       |