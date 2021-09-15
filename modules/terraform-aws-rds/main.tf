resource "aws_db_instance" "db_server" {
  # General config
  identifier                 = var.db_instance_name
  name                       = var.db_name
  username                   = var.master_db_username
  password                   = var.master_db_password
  port                       = 5432

  # Resources
  allocated_storage          = 10
  storage_type               = "gp2"
  instance_class             = var.db_instance_class

  # Engine
  engine                     = "postgres"
  engine_version             = "12.7"

  # Backup config
  snapshot_identifier        = var.snapshot_identifier
  skip_final_snapshot        = true
  final_snapshot_identifier  = "${var.db_instance_name}-termination-snapshot"
  backup_retention_period    = 14 # number of days backups to keep

  # Upgrades
  auto_minor_version_upgrade = true # Allow automated minor version upgrades during maintenance window

  # Access
  publicly_accessible        = false
  vpc_security_group_ids = [
    var.db_server_security_group_id,
  ]

  # Tagging
  copy_tags_to_snapshot      = true
  tags = {
    Terraform    = "true"
  }

  # TODO: Commented this out until we're happy with everything
  //  lifecycle {
  //    prevent_destroy = true
  //  }

  db_subnet_group_name = aws_db_subnet_group.db_server.id

  //  apply_immediately     = true
  //  deletion_protection   = true  # You'll need to change this before a terraform destroy etc
}

resource "aws_db_subnet_group" "db_server" {
  name = "sonarqube-db"
  subnet_ids = var.subnet_ids

  tags = {
    Terraform    = "true"
  }
}
