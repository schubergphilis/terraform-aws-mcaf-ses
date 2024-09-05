terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      configuration_aliases = [aws, aws.route53]
      source                = "hashicorp/aws"
      version               = ">= 4.9.0"
    }
  }
}
