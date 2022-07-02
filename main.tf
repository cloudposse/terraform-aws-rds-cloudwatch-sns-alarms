data "aws_caller_identity" "default" {
  count = module.this.enabled ? 1 : 0
}

module "topic_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["rds", "threshold", "alerts"]

  context = module.this.context
}

resource "aws_sns_topic" "default" {
  count = module.this.enabled ? 1 : 0
  name  = module.topic_label.id
}

module "subscription_label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  attributes = ["rds", "event", "sub"]

  context = module.this.context
}

resource "aws_db_event_subscription" "default" {
  count     = module.this.enabled ? 1 : 0
  name      = module.subscription_label.id
  sns_topic = join("", aws_sns_topic.default.*.arn)

  source_type = "db-instance"
  source_ids  = [var.db_instance_id]

  event_categories = [
    "failover",
    "failure",
    "low storage",
    "maintenance",
    "notification",
    "recovery",
  ]

  depends_on = [
    aws_sns_topic_policy.default
  ]
}

resource "aws_sns_topic_policy" "default" {
  count  = module.this.enabled ? 1 : 0
  arn    = join("", aws_sns_topic.default.*.arn)
  policy = join("", data.aws_iam_policy_document.sns_topic_policy.*.json)
}

data "aws_iam_policy_document" "sns_topic_policy" {
  count = module.this.enabled ? 1 : 0

  statement {
    sid = "AllowManageSNS"

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
    resources = aws_sns_topic.default.*.arn

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = data.aws_caller_identity.default.*.account_id

    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = aws_sns_topic.default.*.arn

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow RDS Event Notification"
    actions   = ["sns:Publish"]
    resources = aws_sns_topic.default.*.arn

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
