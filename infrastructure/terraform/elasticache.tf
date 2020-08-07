data "aws_subnet_ids" "private" {
  vpc_id = local.account.vpc_id

  filter {
    name   = "tag:Name"
    values = ["private-*"]
  }
}

data "aws_region" "region" {}

resource "aws_elasticache_subnet_group" "private" {
  name       = "private-redis"
  subnet_ids = data.aws_subnet_ids.private.ids
}
