output "ses_dkim_tokens" {
  value = aws_ses_domain_dkim.this.dkim_tokens
}
output "ses_domain_arn" {
  value = aws_ses_domain_identity.this.arn
}
