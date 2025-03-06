provider "aws" {
  alias = "route53"

  region = "eu-west-1"
}

module "example" {
  #checkov:skip=CKV_AWS_272: This module does not support lambda code signing at the moment
  providers = { aws = aws, aws.route53 = aws }

  source = "../.."

  domain = "example.com"

  smtp_users = [
    "example_user"
  ]
}
