provider "aws" {
  region = "eu-west-1"
}

module "example" {
  #checkov:skip=CKV_AWS_272: This module does not support lambda code signing at the moment
  source = "../.."

  providers = { aws = aws, aws.route53 = aws }
  domain    = "example.com"
}
