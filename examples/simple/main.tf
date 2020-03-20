### For connecting and provisioning
variable "region" {
  default = "eu-west-2"
}

provider "aws" {
  region = var.region

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

resource "aws_sns_topic" "default" {
  name_prefix = "rds-threshold-alerts"
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  identifier_prefix    = "rds-server-example"
  name                 = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  apply_immediately    = "true"
  skip_final_snapshot  = "true"
}

module "rds_alarms" {
  source         = "../../"
  db_instance_ids = [aws_db_instance.default.id]
  aws_sns_topic_arn = aws_sns_topic.default.arn
}

output "rds_arn" {
  value = aws_db_instance.default.id
}
