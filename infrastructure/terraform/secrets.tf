resource "aws_secretsmanager_secret" "slack_webhook_url" {
  name                           = "slack_webhook_url"
  force_overwrite_replica_secret = true
  replica {
    region = "eu-west-2"
  }
}
