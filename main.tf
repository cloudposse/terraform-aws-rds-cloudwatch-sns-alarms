# resource "aws_cloudwatch_event_target" "sns" {
#   rule       = "${aws_cloudwatch_event_rule.default.name}"
#   target_id  = "SendToSNS"
#   arn        = "${var.sns_topic_arn}"
#   depends_on = ["aws_cloudwatch_event_rule.default"]
#   input      = "${var.sns_message_override}"
# }

locals {
  source_type = var.db_instance_id != "" ? "db-instance" : "db-cluster"
  source_id   = coalesce(var.db_instance_id, var.db_cluster_id)

  event_categories_map = {
    "db-instance" = var.db_instance_event_categories
    "db-cluster"  = var.db_cluster_event_categories
  }
  event_categories = local.event_categories_map[local.source_type]
}

data "aws_caller_identity" "default" {}

# Make a topic
resource "aws_sns_topic" "default" {
  name_prefix = var.sns_topic_name_prefix
}

resource "aws_db_event_subscription" "default" {
  name_prefix      = var.db_event_subscription_prefix_name
  sns_topic        = aws_sns_topic.default.arn
  source_type      = local.source_type
  source_ids       = [local.source_id]
  event_categories = local.event_categories

  depends_on = [aws_sns_topic_policy.default]
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.default.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
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
    resources = ["${aws_sns_topic.default.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"

      values = [
        data.aws_caller_identity.default.account_id
      ]
    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.default.arn]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }

  statement {
    sid       = "Allow RDS Event Notification"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.default.arn}"]

    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}
