resource "aws_route53_record" "dmarc" {
  count    = var.dmarc != null ? 1 : 0
  provider = aws.route53

  name    = "_dmarc.${var.domain}"
  ttl     = 600
  type    = "TXT"
  zone_id = data.aws_route53_zone.default.zone_id

  records = [join(";", compact([
    var.dmarc.policy,
    var.dmarc != null ? var.dmarc.rua != null ? "rua=${var.dmarc.rua}" : null : null,
    var.dmarc != null ? var.dmarc.ruf != null ? "ruf=${var.dmarc.ruf}" : null : null,
  ]))]
}
