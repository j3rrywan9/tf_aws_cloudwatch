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
