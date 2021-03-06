variable "default_role" {
  default = "sirius-ci"
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
