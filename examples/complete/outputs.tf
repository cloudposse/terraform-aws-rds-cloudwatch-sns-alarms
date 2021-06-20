output "rds_alarms_sns_topic_arn" {
  value = module.rds_alarms.sns_topic_arn
}

output "rds_arn" {
  value = aws_db_instance.default.id
}
