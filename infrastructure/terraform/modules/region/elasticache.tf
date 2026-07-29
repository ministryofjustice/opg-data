resource "aws_elasticache_subnet_group" "private" {
  name       = "private-redis"
  subnet_ids = data.aws_subnets.application.ids
  region     = var.region
}
