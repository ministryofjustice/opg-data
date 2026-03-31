data "aws_kms_key" "sirius" {
  key_id = "alias/public_api_bucket_${local.account.serve_bucket_suffix}"
}

locals {
  identity = var.identity_account_id

  oidc_development_role_arn   = "arn:aws:iam::${local.identity}:role/oidc-serve-development"
  oidc_preproduction_role_arn = "arn:aws:iam::${local.identity}:role/oidc-serve-preproduction"
  oidc_production_role_arn    = "arn:aws:iam::${local.identity}:role/oidc-serve-production"

  ci_config = {
    trusted_oidc_role_arns = [
      local.oidc_development_role_arn,
      local.oidc_preproduction_role_arn,
      local.oidc_production_role_arn,
    ]
  }
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
      identifiers = local.ci_config.trusted_oidc_role_arns
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

// Code artifact user

resource "aws_iam_role" "code_artifact_access" {
  count              = terraform.workspace == "development" ? 1 : 0
  name               = "code-artifact-${local.environment}"
  assume_role_policy = data.aws_iam_policy_document.code_artifact_assume.json
}

resource "aws_iam_role_policy" "code_artifact_access" {
  count  = terraform.workspace == "development" ? 1 : 0
  name   = "code-artifact-${local.environment}"
  role   = aws_iam_role.code_artifact_access[0].id
  policy = data.aws_iam_policy_document.code_artifact_access.json
}

data "aws_iam_policy_document" "code_artifact_assume" {
  statement {
    sid    = "AllowAssumeIdentity"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = local.ci_config.trusted_oidc_role_arns
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "code_artifact_access" {
  statement {
    sid    = "AllowReadCodeArtifact"
    effect = "Allow"

    actions = [
      "codeartifact:DescribeDomain",
      "codeartifact:DescribePackageVersion",
      "codeartifact:DescribeRepository",
      "codeartifact:GetAuthorizationToken",
      "codeartifact:GetDomainPermissionsPolicy",
      "codeartifact:GetPackageVersionAsset",
      "codeartifact:GetPackageVersionReadme",
      "codeartifact:GetRepositoryEndpoint",
      "codeartifact:GetRepositoryPermissionsPolicy",
      "codeartifact:ListDomains",
      "codeartifact:ListPackages",
      "codeartifact:ListPackageVersionAssets",
      "codeartifact:ListPackageVersionDependencies",
      "codeartifact:ListPackageVersions",
      "codeartifact:ListRepositories",
      "codeartifact:ListRepositoriesInDomain",
      "codeartifact:ReadFromRepository",
      "codeartifact:UpdatePackageVersionsStatus",
    ]

    resources = [
      "arn:aws:codeartifact:eu-west-1:${local.account.account_id}:repository/opg-moj*",
      "arn:aws:codeartifact:eu-west-1:${local.account.account_id}:domain/opg-moj",
    ]
  }

  statement {
    sid    = "AllowStsGetServiceBearerToken"
    effect = "Allow"

    actions = [
      "sts:GetServiceBearerToken"
    ]

    resources = [
      "arn:aws:sts::${local.account.account_id}:assumed-role/code-artifact*"
    ]
  }
}
