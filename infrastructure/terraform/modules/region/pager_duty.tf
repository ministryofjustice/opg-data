data "pagerduty_vendor" "cloudwatch" {
  name = "Cloudwatch"
}

data "pagerduty_service" "sirius_non_prod" {
  name = "Sirius Non Production Alerts"
}

data "pagerduty_service" "sirius_integrations" {
  name = "Sirius Integrations"
}

resource "pagerduty_service_integration" "cloudwatch_integrations" {
  name    = data.pagerduty_vendor.cloudwatch.name
  service = data.pagerduty_service.sirius_integrations.id
  vendor  = data.pagerduty_vendor.cloudwatch.id
}

resource "pagerduty_service_integration" "cloudwatch_integration_non_production" {
  name    = data.pagerduty_vendor.cloudwatch.name
  service = data.pagerduty_service.sirius_non_prod.id
  vendor  = data.pagerduty_vendor.cloudwatch.id
}
