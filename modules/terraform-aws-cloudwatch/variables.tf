variable "alert_arn" {
  description = "Output of alert ARN from SNS module"
}

variable "db_server_instance" {
  description = "The name of the DB instance"
}

variable "db_identifier" {
  description = "The DB identifier"
}

variable "asg_name" {
  description = "The Auto Scaling group name"
}

variable "target_group_identifier" {
  description = "The TG identifier"
}

variable "load_balancer_identifier" {
  description = "The LB identifier"
}

variable "environment" {
  description = "What environment is this going to be, staging or production"
}
