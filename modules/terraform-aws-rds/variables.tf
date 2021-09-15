variable "db_instance_name" {
  description = "The name of this DB instance"
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  description = "The name of the database"
}

variable "master_db_username" {
  description = "Username for the master DB user"
  type = string
}

variable "master_db_password" {
  description = "Password for the master DB user"
  type = string
}

variable "db_server_security_group_id" {
  description = "Security group ID for the SonarQube DB server"
}

variable "vpc_id" {
  description = "VPC to create this DB instance in"
}

variable "snapshot_identifier" {
  type = string
  default = "snapshot"
}

variable "subnet_ids" {
  description = "Subnet IDs"
}
