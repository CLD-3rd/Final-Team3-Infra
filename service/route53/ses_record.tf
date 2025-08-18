resource "aws_ses_domain_identity" "this" {
  domain = var.domain_name
}

resource "aws_route53_record" "ses_verification" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 600
  records = [aws_ses_domain_identity.this.verification_token]
}

resource "aws_ses_domain_dkim" "this" {
  domain = var.domain_name
}

resource "aws_route53_record" "ses_dkim" {
  count   = length(aws_ses_domain_dkim.this.dkim_tokens)
  zone_id = var.zone_id
  name    = "${aws_ses_domain_dkim.this.dkim_tokens[count.index]}._domainkey.${var.domain_name}"
  type    = "CNAME"
  ttl     = 600
  records = ["${aws_ses_domain_dkim.this.dkim_tokens[count.index]}.dkim.amazonses.com"]
}

output "domain_identity_arn" {
  value = aws_ses_domain_identity.this.arn
}
