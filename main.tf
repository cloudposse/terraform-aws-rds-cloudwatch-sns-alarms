# resource "aws_cloudwatch_event_target" "sns" {
#   rule       = "${aws_cloudwatch_event_rule.default.name}"
#   target_id  = "SendToSNS"
#   arn        = "${var.sns_topic_arn}"
#   depends_on = ["aws_cloudwatch_event_rule.default"]
#   input      = "${var.sns_message_override}"
# }
data "aws_caller_identity" "default" {}

module "sns_topic_default_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${compact(concat(var.attributes, list("rds", "threshold", "alerts")))}"
  tags       = "${var.tags}"
}

# Make a topic
resource "aws_sns_topic" "default" {
  name_prefix = "${module.sns_topic_default_label.id}"
  tags        = "${module.sns_topic_default_label.tags}"
}

module "db_event_subscription_default_label" {
  source     = "git::https://github.com/cloudposse/terraform-terraform-label.git?ref=tags/0.2.1"
  name       = "${var.name}"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  delimiter  = "${var.delimiter}"
  attributes = "${compact(concat(var.attributes, list("rds", "event", "sub")))}"
  tags       = "${var.tags}"
}

resource "aws_db_event_subscription" "default" {
  name_prefix = "${module.db_event_subscription_default_label.id}"
  sns_topic   = "${aws_sns_topic.default.arn}"
  source_type = "db-instance"
  source_ids  = ["${var.db_instance_id}"]
  tags        = "${module.db_event_subscription_default_label.tags}"

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

resource "aws_sns_topic_policy" "default" {
  arn    = "${aws_sns_topic.default.arn}"
  policy = "${data.aws_iam_policy_document.sns_topic_policy.json}"
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
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
        "${data.aws_caller_identity.default.account_id}",
      ]
    }
  }

  statement {
    sid       = "Allow CloudwatchEvents"
    actions   = ["sns:Publish"]
    resources = ["${aws_sns_topic.default.arn}"]

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
