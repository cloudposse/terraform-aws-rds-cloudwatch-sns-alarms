<!-- markdownlint-disable -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_burst_balance_too_low_label"></a> [burst\_balance\_too\_low\_label](#module\_burst\_balance\_too\_low\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_cpu_credit_balance_too_low_label"></a> [cpu\_credit\_balance\_too\_low\_label](#module\_cpu\_credit\_balance\_too\_low\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_cpu_utilization_too_high_label"></a> [cpu\_utilization\_too\_high\_label](#module\_cpu\_utilization\_too\_high\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_disk_queue_depth_too_high_label"></a> [disk\_queue\_depth\_too\_high\_label](#module\_disk\_queue\_depth\_too\_high\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_free_storage_space_threshold_label"></a> [free\_storage\_space\_threshold\_label](#module\_free\_storage\_space\_threshold\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_freeable_memory_too_low_label"></a> [freeable\_memory\_too\_low\_label](#module\_freeable\_memory\_too\_low\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_label"></a> [label](#module\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_subscription_label"></a> [subscription\_label](#module\_subscription\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_swap_usage_too_high_label"></a> [swap\_usage\_too\_high\_label](#module\_swap\_usage\_too\_high\_label) | cloudposse/label/null | 0.24.1 |
| <a name="module_this"></a> [this](#module\_this) | cloudposse/label/null | 0.24.1 |
| <a name="module_topic_label"></a> [topic\_label](#module\_topic\_label) | cloudposse/label/null | 0.24.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_metric_alarm.burst_balance_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_credit_balance_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.cpu_utilization_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.disk_queue_depth_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.free_storage_space_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.freeable_memory_too_low](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_cloudwatch_metric_alarm.swap_usage_too_high](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm) | resource |
| [aws_db_event_subscription.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_event_subscription) | resource |
| [aws_sns_topic.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic) | resource |
| [aws_sns_topic_policy.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sns_topic_policy) | resource |
| [aws_caller_identity.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.sns_topic_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_tag_map"></a> [additional\_tag\_map](#input\_additional\_tag\_map) | Additional tags for appending to tags\_as\_list\_of\_maps. Not added to `tags`. | `map(string)` | `{}` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `1`) | `list(string)` | `[]` | no |
| <a name="input_burst_balance_threshold"></a> [burst\_balance\_threshold](#input\_burst\_balance\_threshold) | The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available. | `number` | `20` | no |
| <a name="input_context"></a> [context](#input\_context) | Single object for setting entire context at once.<br>See description of individual variables for details.<br>Leave string and numeric variables as `null` to use default value.<br>Individual variable settings (non-null) override settings in context object,<br>except for attributes, tags, and additional\_tag\_map, which are merged. | `any` | <pre>{<br>  "additional_tag_map": {},<br>  "attributes": [],<br>  "delimiter": null,<br>  "enabled": true,<br>  "environment": null,<br>  "id_length_limit": null,<br>  "label_key_case": null,<br>  "label_order": [],<br>  "label_value_case": null,<br>  "name": null,<br>  "namespace": null,<br>  "regex_replace_chars": null,<br>  "stage": null,<br>  "tags": {}<br>}</pre> | no |
| <a name="input_cpu_credit_balance_threshold"></a> [cpu\_credit\_balance\_threshold](#input\_cpu\_credit\_balance\_threshold) | The minimum number of CPU credits (t2 instances only) available. | `number` | `20` | no |
| <a name="input_cpu_utilization_threshold"></a> [cpu\_utilization\_threshold](#input\_cpu\_utilization\_threshold) | The maximum percentage of CPU utilization. | `number` | `80` | no |
| <a name="input_db_instance_id"></a> [db\_instance\_id](#input\_db\_instance\_id) | The instance ID of the RDS database instance that you want to monitor. | `string` | n/a | yes |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `namespace`, `environment`, `stage`, `name` and `attributes`.<br>Defaults to `-` (hyphen). Set to `""` to use no delimiter at all. | `string` | `null` | no |
| <a name="input_disk_queue_depth_threshold"></a> [disk\_queue\_depth\_threshold](#input\_disk\_queue\_depth\_threshold) | The maximum number of outstanding IOs (read/write requests) waiting to access the disk. | `number` | `64` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Set to false to prevent the module from creating any resources | `bool` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment, e.g. 'uw2', 'us-west-2', OR 'prod', 'staging', 'dev', 'UAT' | `string` | `null` | no |
| <a name="input_free_storage_space_threshold"></a> [free\_storage\_space\_threshold](#input\_free\_storage\_space\_threshold) | The minimum amount of available storage space in Byte. | `number` | `2000000000` | no |
| <a name="input_freeable_memory_threshold"></a> [freeable\_memory\_threshold](#input\_freeable\_memory\_threshold) | The minimum amount of available random access memory in Byte. | `number` | `64000000` | no |
| <a name="input_id_length_limit"></a> [id\_length\_limit](#input\_id\_length\_limit) | Limit `id` to this many characters (minimum 6).<br>Set to `0` for unlimited length.<br>Set to `null` for default, which is `0`.<br>Does not affect `id_full`. | `number` | `null` | no |
| <a name="input_label_key_case"></a> [label\_key\_case](#input\_label\_key\_case) | The letter case of label keys (`tag` names) (i.e. `name`, `namespace`, `environment`, `stage`, `attributes`) to use in `tags`.<br>Possible values: `lower`, `title`, `upper`.<br>Default value: `title`. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | The naming order of the id output and Name tag.<br>Defaults to ["namespace", "environment", "stage", "name", "attributes"].<br>You can omit any of the 5 elements, but at least one must be present. | `list(string)` | `null` | no |
| <a name="input_label_value_case"></a> [label\_value\_case](#input\_label\_value\_case) | The letter case of output label values (also used in `tags` and `id`).<br>Possible values: `lower`, `title`, `upper` and `none` (no transformation).<br>Default value: `lower`. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Solution name, e.g. 'app' or 'jenkins' | `string` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp' | `string` | `null` | no |
| <a name="input_regex_replace_chars"></a> [regex\_replace\_chars](#input\_regex\_replace\_chars) | Regex to replace chars with empty string in `namespace`, `environment`, `stage` and `name`.<br>If not set, `"/[^a-zA-Z0-9-]/"` is used to remove all characters other than hyphens, letters and digits. | `string` | `null` | no |
| <a name="input_stage"></a> [stage](#input\_stage) | Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release' | `string` | `null` | no |
| <a name="input_swap_usage_threshold"></a> [swap\_usage\_threshold](#input\_swap\_usage\_threshold) | The maximum amount of swap space used on the DB instance in Byte. | `number` | `256000000` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')` | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_sns_topic_arn"></a> [sns\_topic\_arn](#output\_sns\_topic\_arn) | The ARN of the SNS topic |
<!-- markdownlint-restore -->
