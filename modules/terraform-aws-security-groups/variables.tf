variable "security_group_name_prefix" {
  description = "The prefix to prepend to all security group names"
  type        = string
  default     = "sec-grp"
}

variable "vpc_id" {
  description = "VPC ID"
  type = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
}

variable "vpn_cidr_blocks" {
  description = "VPN CIDR blocks"
}

variable "alb_allowed_cidr_blocks" {
  description = "CIDR blocks that are allowed access to ALB"
}
