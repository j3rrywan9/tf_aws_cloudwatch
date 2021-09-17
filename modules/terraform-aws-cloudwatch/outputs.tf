output "sonarqube_container_log_group_name" {
  value = aws_cloudwatch_log_group.sonarqube_container_log_group.name
}
