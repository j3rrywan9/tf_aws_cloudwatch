variable "image_id" {
  type = string
}

variable "cw_demo_instance_type" {
  type = string
}

variable "init_file" {
  description = "The rendered EC2 init file"
}

variable "vpc_security_group_ids" {
  description = "Security group IDs"
}

variable "subnet_ids" {
  description = "Subnet IDs"
}
