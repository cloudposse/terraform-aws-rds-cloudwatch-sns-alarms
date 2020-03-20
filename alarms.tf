locals {
  thresholds = {
    BurstBalanceThreshold     = min(max(var.burst_balance_threshold, 0), 100)
    CPUUtilizationThreshold   = min(max(var.cpu_utilization_threshold, 0), 100)
    CPUCreditBalanceThreshold = max(var.cpu_credit_balance_threshold, 0)
    DiskQueueDepthThreshold   = max(var.disk_queue_depth_threshold, 0)
    FreeableMemoryThreshold   = max(var.freeable_memory_threshold, 0)
    FreeStorageSpaceThreshold = max(var.free_storage_space_threshold, 0)
    SwapUsageThreshold        = max(var.swap_usage_threshold, 0)
  }
}

resource "aws_cloudwatch_metric_alarm" "burst_balance_too_low" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-burst_balance_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["BurstBalanceThreshold"]
  alarm_description   = "Average database storage burst balance over last ${var.period/60} minutes too low, expect a significant performance drop soon"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-cpu_utilization_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average database CPU utilization over last ${var.period/60} minutes too high"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-cpu_credit_balance_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["CPUCreditBalanceThreshold"]
  alarm_description   = "Average database CPU credit balance over last ${var.period/60} minutes too low, expect a significant performance drop soon"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-disk_queue_depth_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description   = "Average database disk queue depth over last ${var.period/60} minutes too high, performance may suffer"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-freeable_memory_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["FreeableMemoryThreshold"]
  alarm_description   = "Average database freeable memory over last ${var.period/60} minutes too low, performance may suffer"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-free_storage_space_threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space over last ${var.period/60} minutes too low"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  count               = length(var.db_instance_ids)
  alarm_name          = "${var.name_prefix}${var.db_instance_ids[count.index]}-swap_usage_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["SwapUsageThreshold"]
  alarm_description   = "Average database swap usage over last ${var.period/60} minutes too high, performance may suffer"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = var.db_instance_ids[count.index]
  }
}
