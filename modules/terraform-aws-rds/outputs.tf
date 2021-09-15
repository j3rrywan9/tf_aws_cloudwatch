output "db_server_hostname" {
  value = aws_db_instance.db_server.address
}

output "db_name" {
  value = aws_db_instance.db_server.name
}

# e.g. jdbc:postgresql://sonar.ciyhsvomvkla.us-east-1.rds.amazonaws.com:5432/sonarqubedb
output "sonar_jdbc_url" {
  value = "jdbc:postgresql://${aws_db_instance.db_server.address}:5432/${var.db_name}"
}
