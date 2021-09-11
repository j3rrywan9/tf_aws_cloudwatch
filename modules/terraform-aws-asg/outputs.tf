output "cw_demo_asg_arn" {
  value = aws_autoscaling_group.cw_demo_asg.arn
}

output "cw_demo_asg_name" {
  value = aws_autoscaling_group.cw_demo_asg.name
}
