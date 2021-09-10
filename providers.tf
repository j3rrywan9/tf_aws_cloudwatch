provider "aws" {
  allowed_account_ids = [var.aws_account_id]
  region              = var.aws_region
  access_key          = var.aws_access_key
  secret_key          = var.aws_secret_key
}
