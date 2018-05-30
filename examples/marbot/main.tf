variable "marbot_endpoint_id" {
  default = ""
}

locals {
  marbot_endpoint = {
    endpoint_id = "${var.marbot_endpoint_id}"
    stage       = "v1"
  }
}

resource "aws_sns_topic_subscription" "subscribe_marbot" {
  count     = "${var.marbot_endpoint_id != "" ? 1 : 0}"
  topic_arn = "${aws_sns_topic.default.arn}"
  protocol  = "https"
  endpoint  = "https://api.marbot.io/${local.marbot_endpoint["Stage"]}/endpoint/${local.marbot_endpoint["EndpointId"]}"
}
