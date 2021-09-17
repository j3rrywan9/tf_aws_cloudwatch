variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "cloudwatch_log_group_name" {
  description = "CloudWatch Logs log group name"
  type = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "cw_demo_asg_arn" {
  type = string
}

variable "container_name" {
  description = "Docker container name"
  type        = string
}

variable "docker_image" {
  description = "The Docker image"
  type        = string
}

variable "container_port" {
  description = "Docker container port"
  type = number
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN"
  type = string
}

variable "sonar_jdbc_url" {
  type = string
}

variable "sonar_jdbc_username" {
  description = "SonarQube DB JDBC username"
  type        = string
}

variable "sonar_jdbc_password" {
  description = "SonarQube DB JDBC password"
  type        = string
}
