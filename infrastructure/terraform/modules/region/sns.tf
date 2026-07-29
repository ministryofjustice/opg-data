resource "aws_sns_topic" "rest_api" {
  name              = "rest-api"
  kms_master_key_id = aws_kms_key.cloudwatch_sns.key_id
  region            = var.region
}

resource "aws_sns_topic_subscription" "cloudwatch_sns_subscription_integrations" {
  topic_arn              = aws_sns_topic.rest_api.arn
  protocol               = "https"
  endpoint_auto_confirms = true
  endpoint               = "https://events.pagerduty.com/integration/${var.account.is_production == "true" ? pagerduty_service_integration.cloudwatch_integrations.integration_key : pagerduty_service_integration.cloudwatch_integration_non_production.integration_key}/enqueue"
  region                 = var.region
}

resource "aws_kms_key" "cloudwatch_sns" {
  description             = "KMS Key for Cloudwatch related SNS Encryption for Integration Notifications"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.cloudwatch_sns_kms.json
  enable_key_rotation     = true
  region                  = var.region
}

resource "aws_kms_alias" "cloudwatch_sns" {
  name          = "alias/integrations-sns-${terraform.workspace}"
  target_key_id = aws_kms_key.cloudwatch_sns.key_id
  region        = var.region
}

data "aws_iam_policy_document" "cloudwatch_sns_kms" {
  statement {
    sid       = "Allow Key to be used for Encryption"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey*",
    ]
    principals {
      type        = "Service"
      identifiers = ["cloudwatch.amazonaws.com"]
    }
  }
  statement {
    sid       = "Enable Root account permissions on Key"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${var.account.account_id}:root",
      ]
    }
  }
}
