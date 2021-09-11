resource "aws_security_group" "ssh-non-prod-vpn" {
  name = "${var.security_group_name_prefix}-ssh-non-prod-vpn"
  description = "Allow SSH access from Non-Prod VPN"
  vpc_id = var.vpc_id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    description = "Non Prod VPN SSH Access"
    cidr_blocks = var.vpn_cidr_blocks
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "alb" {
  name        = "${var.security_group_name_prefix}-alb"
  description = "CloudWatch demo ALB security group"
  vpc_id      = var.vpc_id

  tags = {
    Name         = "${var.security_group_name_prefix}-alb"
    Terraform    = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "https_vpn_access" {
  description = "Non-Prod VPN access via HTTPS"
  type = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = var.alb_allowed_cidr_blocks
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "http_vpn_access" {
  description = "Non-Prod VPN access via HTTP"
  type = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = var.alb_allowed_cidr_blocks
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "asg" {
  name        = "${var.security_group_name_prefix}-asg"
  description = "CloudWatch demo ASG security group"
  vpc_id      = var.vpc_id

  tags = {
    Name         = "${var.security_group_name_prefix}-asg"
    Terraform    = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "asg_allow_all" {
  description = "Allow all outbound traffic from ASG"
  type = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = [
    "0.0.0.0/0",
  ]
  security_group_id = aws_security_group.asg.id
}
