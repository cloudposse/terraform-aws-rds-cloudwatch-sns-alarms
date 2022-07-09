provider "aws" {
  region = var.region
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier           = module.this.id
  db_name              = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  apply_immediately    = "true"
  skip_final_snapshot  = "true"
}

module "rds_alarms" {
  source         = "../../"
  db_instance_id = aws_db_instance.default.id
  sns_topic_arn  = module.sns.sns_topic_arn
  context        = module.this.context
}

module "sns" {
  source  = "cloudposse/sns-topic/aws"
  version = "0.20.1"

  allowed_aws_services_for_sns_published = ["cloudwatch.amazonaws.com"]

  context = module.this.context
}
