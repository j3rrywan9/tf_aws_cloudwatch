output "aws_iam_account_alias" {
  value = data.aws_iam_account_alias.this
}

output "vpc_id" {
  value = data.aws_vpc.this.id
}

output "default_subnet_ids" {
  value = data.aws_subnet_ids.default.ids
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
