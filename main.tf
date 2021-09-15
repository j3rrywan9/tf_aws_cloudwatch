module "security_groups" {
  source                  = "./modules/terraform-aws-security-groups"
  server_port             = 80
  container_port          = var.container_port
  vpn_cidr_blocks         = var.vpn_cidr_blocks
  alb_allowed_cidr_blocks = var.alb_allowed_cidr_blocks
  vpc_id                  = data.aws_vpc.this.id
}

module "alb" {
  source     = "./modules/terraform-aws-alb"
  vpc_id     = data.aws_vpc.this.id
  subnet_ids = data.aws_subnet_ids.default.ids
  security_groups = [
    module.security_groups.alb_security_group_id,
  ]
  container_port = var.container_port

  depends_on = [
    module.security_groups,
  ]
}

module "asg" {
  source                = "./modules/terraform-aws-asg"
  image_id              = var.image_id
  cw_demo_instance_type = var.cw_demo_instance_type
  init_file             = data.template_file.init.rendered
  vpc_security_group_ids = [
    module.security_groups.asg_security_group_id,
    module.security_groups.ssh_non_prod_vpn_security_group_id,
  ]
  subnet_ids = data.aws_subnet_ids.default.ids
}

module "ecs" {
  source               = "./modules/terraform-aws-ecs"
  ecs_cluster_name     = var.ecs_cluster_name
  cw_demo_asg_arn      = module.asg.cw_demo_asg_arn
  container_name       = var.container_name
  container_port       = var.container_port
  alb_target_group_arn = module.alb.alb_target_group_arn
  sonar_jdbc_url       = module.rds.sonar_jdbc_url
  sonar_jdbc_username  = var.sonar_jdbc_username
  sonar_jdbc_password  = var.sonar_jdbc_password
}

module "rds" {
  source                      = "./modules/terraform-aws-rds"
  db_server_security_group_id = module.security_groups.db_server_security_group_id
  vpc_id                      = data.aws_vpc.this.id
  db_instance_name            = var.db_server_instance
  db_instance_class           = var.db_server_instance_class
  db_name                     = var.db_name
  subnet_ids                  = data.aws_subnet_ids.default.ids
  master_db_username          = var.master_db_username
  master_db_password          = var.master_db_password
  snapshot_identifier         = var.snapshot_identifier
}

module "sns" {
  source           = "./modules/terraform-aws-sns"
  account_id       = var.aws_account_id
  recipient        = var.alert_email_address
  cw_demo_asg_name = module.asg.cw_demo_asg_name
}

module "cloudwatch" {
  source                   = "./modules/terraform-aws-cloudwatch"
  alert_arn                = module.sns.alert_arn
  environment              = var.environment
  db_server_instance       = var.db_server_instance
  db_identifier            = module.rds.db_identifier
  asg_name                 = module.asg.cw_demo_asg_name
  load_balancer_identifier = module.alb.alb_identifier
  target_group_identifier  = module.alb.alb_target_group_arn
}
