resource "aws_route53_record" "ses_dkim" {
  for_each = { for token in var.ses_dkim_tokens : token => token }

  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${each.key}._domainkey.${var.domain_name}"
  type    = "CNAME"
  ttl     = 600
  records = ["${each.key}.dkim.amazonses.com"]
}