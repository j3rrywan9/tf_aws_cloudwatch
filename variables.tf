variable "aws_account_id" {
  description = "The account ID of the member account"
  type        = string
  default     = "950350094460"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_access_key" {
  type        = string
  description = "AWS access key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS secret key"
}

variable "vpn_cidr_blocks" {
  description = "VPN CIDR blocks"
  type        = list(string)
  default     = ["98.42.201.180/32"]
}

variable "alb_allowed_cidr_blocks" {
  description = "CIDR blocks that are allowed to access ALB"
  type        = list(string)
  default     = ["98.42.201.180/32"]
}

variable "image_id" {
  description = "AMI image ID"
  type        = string
  # Amazon Linux 2 ECS-optimized AMI in us-east-1
  default = "ami-03db9b2aac6af477d"
}

variable "cw_demo_instance_type" {
  type    = string
  default = "t2.2xlarge"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "cw-demo-cluster"
}

variable "container_name" {
  description = "Docker container name"
  type        = string
  default     = "sonarqube"
}

variable "container_port" {
  description = "Docker container port"
  type        = number
  default     = 9000
}

variable "alert_email_address" {
  description = "The email address who will receive alerts"
  type        = string
}

variable "db_server_instance" {
  description = "The name of the DB instance"
  type        = string
  default     = "sonar"
}

variable "db_server_instance_class" {
  description = "What size of DB instance to use, e.g. db.t3.medium"
  type        = string
  default     = "db.t3.medium"
}

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "sonarqubedb"
}

variable "master_db_username" {
  description = "Username for the master DB user"
  type        = string
  default     = "postgres"
}

variable "master_db_password" {
  description = "Password for the master DB user"
}

# If you wish to seed a DB from a backup, set the name of the snapshot here
variable "snapshot_identifier" {
  default = ""
}

variable "sonar_jdbc_username" {
  description = "SonarQube DB JDBC username"
  type        = string
  default     = "sonar"
}

variable "sonar_jdbc_password" {
  description = "SonarQube DB JDBC password"
  type        = string
  default     = "sonar"
}
