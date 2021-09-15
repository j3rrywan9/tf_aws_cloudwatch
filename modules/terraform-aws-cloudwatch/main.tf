resource "aws_cloudwatch_metric_alarm" "db_diskusage" {
  alarm_name          = "tf-${var.db_server_instance}-diskusage-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 60 * 60 # Check every hour
  statistic           = "Average"
  threshold           = 5 * 1024 * 1024 * 1024 # 5Gb
  alarm_description   = "Insufficient spare Disk Space for SonarQube ${var.environment} RDS"

  alarm_actions = [
    var.alert_arn,
  ]

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
}

# Alert when CPU usage is above 50%, and remains there for more than an hour
resource "aws_cloudwatch_metric_alarm" "db_cpuutilization" {
  alarm_name          = "tf-${var.db_server_instance}-cpuutilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "12"                                             # number of 5 minute period in an hour
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 60 * 5                                           # Check every 5 minutes
  statistic           = "Minimum"                                        # Only alarm if over 50% for the entire hour
  threshold           = "50"                                             # 50%
  alarm_description   = "CPU Utilization > 50% for last hour for SonarQube RDS"

  alarm_actions = [
    var.alert_arn,
  ]

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
}

# Alert when free memory drops below 500MB and remains there for more than 6 hours
# FreeableMemory is the metric we have, so we want to alert on < 500MB Freeable Memory
resource "aws_cloudwatch_metric_alarm" "db_memory" {
  alarm_name          = "tf-${var.db_server_instance}-memory-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "12"                                            # number of 30 minute periods in 6 hours
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = 60 * 30                                         # Check every 30 minutes
  statistic           = "Minimum"                                       # Only alarm if over the threshold for the entire period
  threshold           = 500 * 1024 * 1024                               # See resource comment above
  alarm_description   = "Free Memory < 500MB for last 6 hours for SonarQube RDS"

  alarm_actions = [
    var.alert_arn,
  ]

  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
}

# Alert when CPU usage is above 50%, and remains there for more than an hour
resource "aws_cloudwatch_metric_alarm" "ec2_cpuutilization" {
  alarm_name          = "tf-sonarqube-server-ec2-cpuutilization-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "12"                                             # number of 5 minute period in an hour
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 * 5                                           # Check every 5 minutes
  statistic           = "Minimum"                                        # Only alarm if over 50% for the entire hour
  threshold           = "50"                                             # 50%
  alarm_description   = "CPU Utilization > 50% for last hour for SonarQube server EC2"

  alarm_actions = [
    var.alert_arn,
  ]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# Alert when EC2 status check fails
resource "aws_cloudwatch_metric_alarm" "ec2_statuscheck" {
  alarm_name          = "tf-sonarqube-server-ec2-status-check-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 60 * 5                                           # Check every 5 minutes
  statistic           = "Maximum"
  unit                = "Count"
  threshold           = "1"
  alarm_description   = "Status Check Failed for SonarQube server EC2"

  alarm_actions = [
    var.alert_arn,
  ]

  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# Alert when there's unhealthy hosts
resource "aws_cloudwatch_metric_alarm" "tg_unhealthy" {
  alarm_name          = "tf-sonarqube-tg-health-check-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60 * 5                                           # Check every 5 minutes
  statistic           = "Minimum"
  unit                = "Count"
  threshold           = "1"
  alarm_description   = "Unhealthy SonarQube hosts"

  alarm_actions = [
    var.alert_arn,
  ]

  dimensions = {
    TargetGroup = var.target_group_identifier
    LoadBalancer = var.load_balancer_identifier
  }
}
