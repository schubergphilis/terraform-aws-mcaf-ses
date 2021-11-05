terraform {
  required_version = ">= 0.14"

  required_providers {
    aws = {
      configuration_aliases = [aws, aws.route53]
      source                = "hashicorp/aws"
    }
  }
}
