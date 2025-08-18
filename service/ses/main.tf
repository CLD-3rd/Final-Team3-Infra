resource "aws_ses_domain_identity" "this" {
  domain = var.domain_name
}

resource "aws_route53_record" "ses_verification" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_ses_domain_dkim" "this" {
  domain = var.domain_name
}

data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}