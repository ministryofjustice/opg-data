resource "aws_sns_topic" "rest_api" {
  name              = "rest-api"
  kms_master_key_id = aws_kms_key.cloudwatch_sns.key_id
  tags              = local.default_tags
}

resource "aws_kms_key" "cloudwatch_sns" {
  description             = "KMS Key for Cloudwatch related SNS Encryption for Integration Slack Notifications"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.cloudwatch_sns_kms.json
  enable_key_rotation     = true
  tags                    = local.default_tags
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
        "arn:aws:iam::${local.account.account_id}:root",
      ]
    }
  }
}

module "notify_slack" {
  source = "github.com/terraform-aws-modules/terraform-aws-notify-slack.git?ref=v2.10.0"

  sns_topic_name   = aws_sns_topic.rest_api.name
  create_sns_topic = false

  lambda_function_name = "notify-slack"

  cloudwatch_log_group_retention_in_days = 14

  slack_webhook_url = data.aws_secretsmanager_secret_version.slack_webhook_url.secret_string
  slack_channel     = local.account.alerts_channel
  slack_username    = "aws"
  slack_emoji       = ":warning:"

  tags = local.default_tags
}
