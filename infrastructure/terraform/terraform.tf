terraform {
  backend "s3" {
    bucket         = "opg.terraform.state"
    key            = "opg-data-deputy-reporting-shared/terraform.tfstate"
    encrypt        = true
    region         = "eu-west-1"
    role_arn       = "arn:aws:iam::311462405659:role/integrations-ci"
    dynamodb_table = "remote_lock"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.52.0"
    }
    pagerduty = {
      source  = "pagerduty/pagerduty"
      version = "1.10.0"
    }
  }
  required_version = ">= 1.0.0"
}


provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn     = "arn:aws:iam::${local.account.account_id}:role/${var.default_role}"
    session_name = "terraform-session"
  }
}

# Configure the PagerDuty provider
provider "pagerduty" {
  token = var.pagerduty_token
}
