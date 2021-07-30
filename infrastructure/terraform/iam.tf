data "aws_kms_key" "sirius" {
  key_id = "alias/public_api_bucket_${local.account.serve_bucket_suffix}"
}

resource "aws_iam_role" "serve_integration" {
  name               = "serve-assume-role-ci-${local.environment}"
  assume_role_policy = data.aws_iam_policy_document.serve_ci_sirius.json
}

data "aws_iam_policy_document" "serve_ci_sirius" {
  statement {
    sid    = "AllowAssumeServeCI"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::631181914621:user/serve-opg-ci"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "describe_kms" {
  statement {
    sid       = "AllowDescribeKMS"
    effect    = "Allow"
    resources = [data.aws_kms_key.sirius.arn]
    actions = [
      "kms:DescribeKey"
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  name   = "kms-describe-${local.environment}"
  role   = aws_iam_role.serve_integration.id
  policy = data.aws_iam_policy_document.describe_kms.json
}
