output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "asg_security_group_id" {
  value = aws_security_group.asg.id
}

output "ssh_non_prod_vpn_security_group_id" {
  value = aws_security_group.ssh-non-prod-vpn.id
}
