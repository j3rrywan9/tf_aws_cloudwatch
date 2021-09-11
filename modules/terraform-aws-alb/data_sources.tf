data "aws_acm_certificate" "cw_demo" {
  domain   = "cwdemo.cafefullstack.com"
  statuses = ["ISSUED"]
}
