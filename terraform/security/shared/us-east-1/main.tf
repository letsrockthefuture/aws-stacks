resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com",
  ]

  thumbprint_list = [
    "a031c46782e6e6c662c2c87c76da9aa62ccabd8e",
  ]
}

module "github_actions_iam_assumable_role_with_oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "~> 4.7.0"

  create_role = true
  role_name   = "github-actions-assume-role-with-oidc"

  role_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]

  provider_url = "token.actions.githubusercontent.com"

  oidc_fully_qualified_audiences = [
    "sts.amazonaws.com",
  ]

  oidc_subjects_with_wildcards = [
    "repo:letsrockthefuture/*:*",
  ]

  depends_on = [
    aws_iam_openid_connect_provider.github_actions,
  ]
}
