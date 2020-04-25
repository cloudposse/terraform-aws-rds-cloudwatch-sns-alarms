locals {
  label_name = coalesce(var.name, var.db_instance_id)
}

module "label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  namespace   = var.namespace
  environment = var.environment
  stage       = var.stage
  name        = local.label_name
  delimiter   = var.delimiter
  tags        = var.tags
}

module "label-burst_balance_too_low" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["burst_balance_too_low"])
}
module "label-cpu_utilization_too_high" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["cpu_utilization_too_high"])
}
module "label-cpu_credit_balance_too_low" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["cpu_credit_balance_too_low"])
}
module "label-disk_queue_depth_too_high" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["disk_queue_depth_too_high"])
}
module "label-freeable_memory_too_low" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["freeable_memory_too_low"])
}
module "label-free_storage_space_threshold" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["free_storage_space_threshold"])
}
module "label-swap_usage_too_high" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  context    = module.label.context
  attributes = concat(var.attributes, ["swap_usage_too_high"])
}
