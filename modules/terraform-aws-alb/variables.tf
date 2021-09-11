variable "security_groups" {
  description = "Security groups to apply to the ALB"
}

variable "subnet_ids" {
  description = "Subnet IDs"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "container_port" {
  description = "Docker container port"
  type = number
}
