resource "aws_route53_record" "domain_spf" {
  provider = aws.route53

  name    = aws_ses_domain_identity.default.domain
  records = ["v=spf1 include:amazonses.com -all"]
  ttl     = "600"
  type    = "TXT"
  zone_id = data.aws_route53_zone.default.zone_id
}

resource "aws_route53_record" "mail_from_spf" {
  provider = aws.route53

  name    = aws_ses_domain_mail_from.default.mail_from_domain
  records = ["v=spf1 include:amazonses.com -all"]
  ttl     = "600"
  type    = "TXT"
  zone_id = data.aws_route53_zone.default.zone_id
}
