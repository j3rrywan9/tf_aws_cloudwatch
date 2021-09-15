# An account alias must be created beforehand
data "aws_iam_account_alias" "this" {}

# A tag "Name: [account_alias]" must be created beforehand
data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [data.aws_iam_account_alias.this.account_alias]
  }
}

# A tag "type: default" must be created beforehand
data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.this.id
  tags = {
    type = "default"
  }
}

data "template_file" "init" {
  template = file("${path.module}/templates/ec2-init.sh.tpl")

  vars = {
    db_server_hostname  = module.rds.db_server_hostname
    db_name             = var.db_name
    master_db_username  = var.master_db_username
    master_db_password  = var.master_db_password
    db_server_hostname  = module.rds.db_server_hostname
    sonar_jdbc_url      = module.rds.sonar_jdbc_url
    sonar_jdbc_username = var.sonar_jdbc_username
    sonar_jdbc_password = var.sonar_jdbc_password
    ecs_cluster_name    = var.ecs_cluster_name
  }
}
