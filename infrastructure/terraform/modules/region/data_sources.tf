data "aws_vpc" "sirius" {
  filter {
    name   = "tag:Name"
    values = ["Sirius-${var.account.account_name}-vpc"]
  }
  region = var.region
}

data "aws_subnets" "application" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.sirius.id]
  }

  filter {
    name = "tag:Name"
    values = [
      "application-*",
    ]
  }
  region = var.region
}
