moved {
  from = aws_elasticache_subnet_group.private
  to   = module.region["eu-west-1"].aws_elasticache_subnet_group.private
}

moved {
  from = aws_kms_alias.cloudwatch_logs_alias
  to   = module.region["eu-west-1"].aws_kms_alias.cloudwatch_sns
}

moved {
  from = aws_kms_key.cloudwatch_sns
  to   = module.region["eu-west-1"].aws_kms_key.cloudwatch_sns
}

moved {
  from = aws_sns_topic.rest_api
  to   = module.region["eu-west-1"].aws_sns_topic.rest_api
}

moved {
  from = aws_sns_topic_subscription.cloudwatch_sns_subscription_integrations
  to   = module.region["eu-west-1"].aws_sns_topic_subscription.cloudwatch_sns_subscription_integrations
}

moved {
  from = pagerduty_service_integration.cloudwatch_integration_non_production
  to   = module.region["eu-west-1"].pagerduty_service_integration.cloudwatch_integration_non_production
}

moved {
  from = pagerduty_service_integration.cloudwatch_integrations
  to   = module.region["eu-west-1"].pagerduty_service_integration.cloudwatch_integrations
}
