output "rds_alarms_sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = module.rds_alarms.sns_topic_arn
}

output "rds_arn" {
  description = "The ARN of the RDS"
  value       = aws_db_instance.default.id
}
