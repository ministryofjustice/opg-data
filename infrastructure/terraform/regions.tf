module "region" {
  for_each = local.account.regions
  source   = "./modules/region"

  account = local.account
  region  = each.value
}
