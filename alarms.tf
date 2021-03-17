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
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-burst_balance_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "BurstBalance"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["BurstBalanceThreshold"]
  alarm_description   = "Average database storage burst balance over last ${var.period / 60} minutes too low, expect a significant performance drop soon"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = each.name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-cpu_utilization_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["CPUUtilizationThreshold"]
  alarm_description   = "Average database CPU utilization over last ${var.period / 60} minutes too high"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = veach.value
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_credit_balance_too_low" {
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-cpu_credit_balance_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUCreditBalance"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["CPUCreditBalanceThreshold"]
  alarm_description   = "Average database CPU credit balance over last ${var.period / 60} minutes too low, expect a significant performance drop soon"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = veach.value
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-disk_queue_depth_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["DiskQueueDepthThreshold"]
  alarm_description   = "Average database disk queue depth over last ${var.period / 60} minutes too high, performance may suffer"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = veach.value
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-freeable_memory_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["FreeableMemoryThreshold"]
  alarm_description   = "Average database freeable memory over last ${var.period / 60} minutes too low, performance may suffer"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = veach.value
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-free_storage_space_threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = var.evaluation_periods
  datapoints_to_alarm = var.datapoints_to_alarm
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["FreeStorageSpaceThreshold"]
  alarm_description   = "Average database free storage space over last ${var.period / 60} minutes too low"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = veach.value
  }
}

resource "aws_cloudwatch_metric_alarm" "swap_usage_too_high" {
  for_each            = var.db_instance_ids
  alarm_name          = "${var.name_prefix}${each.value}-swap_usage_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "SwapUsage"
  namespace           = "AWS/RDS"
  period              = var.period
  statistic           = "Average"
  threshold           = local.thresholds["SwapUsageThreshold"]
  alarm_description   = "Average database swap usage over last ${var.period / 60} minutes too high, performance may suffer"
  alarm_actions       = [var.aws_sns_topic_arn]
  ok_actions          = [var.aws_sns_topic_arn]

  dimensions = {
    DBInstanceIdentifier = veach.value
  }
}

resource "aws_cloudwatch_metric_alarm" "rapid-free-space-decrease" {
  for_each                  = var.db_instance_ids
  alarm_name                = "${var.name_prefix}${var.db_master_ids[count.index]}-rapid-free-space-decrease"
  comparison_operator       = "LessThanLowerThreshold"
  evaluation_periods        = "2"
  threshold_metric_id       = "e1"
  alarm_description         = "RDS Free storage space"
  insufficient_data_actions = [var.aws_sns_topic_arn]
  ok_actions                = [var.aws_sns_topic_arn]
  alarm_actions             = [var.aws_sns_topic_arn]

  metric_query {
    id          = "e1"
    expression  = "ANOMALY_DETECTION_BAND(m1)"
    label       = "FreeStorageSpace (Expected)"
    return_data = "true"
  }

  metric_query {
    id          = "m1"
    return_data = "true"

    metric {
      metric_name = "FreeStorageSpace"
      namespace   = "AWS/RDS"
      period      = "300"
      stat        = "Average"

      dimensions = {
        DBInstanceIdentifier = var.db_master_ids[count.index]
      }
    }
  }
}
