locals {
  mail_from_domain = var.mail_from_domain != null ? var.mail_from_domain : "mail.${var.domain}"
}

data "aws_region" "current" {}

data "aws_route53_zone" "default" {
  provider = aws.route53

  name = var.domain
}

// Configure domain identity
resource "aws_ses_domain_identity" "default" {
  domain = var.domain
}

resource "aws_ses_domain_identity_verification" "default" {
  domain     = aws_ses_domain_identity.default.id
  depends_on = [aws_route53_record.ses_verification]
}

resource "aws_route53_record" "ses_verification" {
  provider = aws.route53

  name    = "_amazonses"
  records = [aws_ses_domain_identity.default.verification_token]
  ttl     = "600"
  type    = "TXT"
  zone_id = data.aws_route53_zone.default.zone_id
}

// Configure MAIL FROM domain
resource "aws_ses_domain_mail_from" "default" {
  domain           = aws_ses_domain_identity.default.domain
  mail_from_domain = local.mail_from_domain
}

resource "aws_route53_record" "mail_from_mx" {
  provider = aws.route53

  name    = aws_ses_domain_mail_from.default.mail_from_domain
  records = [format("10 feedback-smtp.%s.amazonses.com", data.aws_region.current.name)]
  ttl     = "600"
  type    = "MX"
  zone_id = data.aws_route53_zone.default.zone_id
}

// Configure inbound mail
resource "aws_route53_record" "domain_mx" {
  provider = aws.route53

  name    = var.domain
  records = [format("10 inbound-smtp.%s.amazonaws.com", data.aws_region.current.name)]
  ttl     = 600
  type    = "MX"
  zone_id = data.aws_route53_zone.default.zone_id
}
