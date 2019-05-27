output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = "${local.aws_sns_topic_arn}"
}

output "sns_topic_name" {
  description = "The SNS topic name"
  value       = "${local.aws_sns_topic_name}"
}
