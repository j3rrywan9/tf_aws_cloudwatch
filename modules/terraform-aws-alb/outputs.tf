output "alb_target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
