resource "aws_lb" "alb" {
  name               = "cw-demo-alb"
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnet_ids

  tags = {
    Terraform    = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  name = "cw-demo-alb-tg"
  port = var.container_port
  protocol = "HTTP"
  # TODO: switch to "ip" when using the "awsvpc" network mode
  target_type = "instance"
  vpc_id = var.vpc_id

  health_check {
    matcher = "200"
    path = "/api/system/status"
  }

  tags = {
    Terraform    = "true"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# forward HTTPS requests to target group
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.cw_demo.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.alb_target_group.arn
  }

  lifecycle {
    create_before_destroy = true
  }
}

# redirect HTTP requests to HTTPS
resource "aws_lb_listener" "redirect_https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}
