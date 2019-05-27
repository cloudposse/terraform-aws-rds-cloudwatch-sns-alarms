terraform {
  backend "s3" {}
}

data "aws_caller_identity" "default" {}

resource "aws_db_event_subscription" "default" {
  name_prefix = "${var.alarm_name_prefix}${var.db_instance_id}-"
  sns_topic   = "${local.aws_sns_topic_arn}"

  source_type = "db-instance"
  source_ids  = ["${var.db_instance_id}"]

  event_categories = [
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "recovery",
  ]

  depends_on = ["aws_sns_topic_policy.default"]
}

# Make a topic
resource "aws_sns_topic" "default_prefix" {
  count       = "${var.sns_topic == "" ? 1 : 0}"
  name_prefix = "rds-threshold-alerts"
}

resource "aws_sns_topic" "default" {
  count = "${var.sns_topic != "" ? 1 : 0}"
  name  = "${var.sns_topic}"
}

locals {
  aws_sns_topic_arn = "${var.sns_topic == "" ?
                       element(concat(aws_sns_topic.default_prefix.*.arn, list("")), 0) :
                       element(concat(aws_sns_topic.default.*.arn, list("")), 0)}"

  aws_sns_topic_name = "${var.sns_topic == "" ?
                        element(concat(aws_sns_topic.default_prefix.*.name, list("")), 0) :
                        var.sns_topic}"
}

resource "aws_sns_topic_policy" "default" {
  arn    = "${local.aws_sns_topic_arn}"
  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  policy_id = "__default_policy_ID"

  statement {
    sid = "__default_statement_ID"

    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]

    effect    = "Allow"
    resources = ["${local.aws_sns_topic_arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        "${data.aws_caller_identity.default.account_id}",
      ]
    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = ["${local.aws_sns_topic_arn}"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow RDS Event Notification"
    actions   = ["sns:Publish"]
    resources = ["${local.aws_sns_topic_arn}"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
