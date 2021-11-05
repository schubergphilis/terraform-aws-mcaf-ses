resource "aws_ses_domain_dkim" "default" {
  domain = aws_ses_domain_identity.default.domain
}

resource "aws_route53_record" "dkim" {
  count = 3

  provider = aws.route53

  name    = format("%s._domainkey.%s", element(aws_ses_domain_dkim.default.dkim_tokens, count.index), var.domain)
  records = [format("%s.dkim.amazonses.com", element(aws_ses_domain_dkim.default.dkim_tokens, count.index))]
  ttl     = 600
  type    = "CNAME"
  zone_id = data.aws_route53_zone.default.zone_id
}
