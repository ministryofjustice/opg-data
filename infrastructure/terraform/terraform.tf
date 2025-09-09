terraform {
  backend "s3" {
    bucket  = "opg.terraform.state"
    key     = "opg-data-deputy-reporting-shared/terraform.tfstate"
    encrypt = true
    region  = "eu-west-1"
    assume_role = {
      role_arn = "arn:aws:iam::311462405659:role/modernising-lpa-state-access"
    }
    dynamodb_table = "remote_lock"
  }
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
