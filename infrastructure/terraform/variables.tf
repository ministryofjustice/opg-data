locals {
  environment = terraform.workspace
  account     = contains(keys(var.accounts), local.environment) ? var.accounts[local.environment] : var.accounts.development

  default_tags = {
    application            = "Data"
    business-unit          = "OPG"
    environment-name       = local.environment
    infrastructure-support = "OPG WebOps: opgteam@digital.justice.gov.uk"
    is-production          = local.account.is_production
    owner                  = "OPG"
    service-area           = "Shared OPG"
    source-code            = "https://github.com/ministryofjustice/opg-data"
  }
}


variable "default_role" {
  default = "opg-data-development-ci"
  type    = string
}

variable "pagerduty_token" {
  type = string
}

variable "accounts" {
  type = map(
    object({
      account_id          = string
      alerts_channel      = string
      is_production       = string
      vpc_id              = string
      serve_bucket_suffix = string
    })
  )
}

variable "identity_account_id" {
  description = "Account ID that owns the OIDC serve roles"
  type        = string
}
