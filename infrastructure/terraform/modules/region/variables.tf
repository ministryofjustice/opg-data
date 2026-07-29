variable "account" {
  type = object({
    account_id          = string
    account_name        = string
    alerts_channel      = string
    is_production       = string
    regions             = set(string)
    serve_bucket_suffix = string
  })
}

variable "region" {
  description = "Current Region"
  type        = string
}
