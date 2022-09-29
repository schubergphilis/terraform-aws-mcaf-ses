resource "aws_route53_record" "dmarc" {
  provider = aws.route53

  name    = "_dmarc.${var.domain}"
  records = ["v=DMARC1;p=reject;sp=reject"]
  ttl     = 600
  type    = "TXT"
  zone_id = data.aws_route53_zone.default.zone_id
}
