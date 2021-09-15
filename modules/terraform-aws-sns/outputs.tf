output "alert_arn" {
  value = aws_sns_topic.cw_demo_alerts.arn  
}
