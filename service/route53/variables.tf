variable "domain_name" {
  description = "Route53에 등록할 최상위 도메인 이름"
  type        = string
}
variable "ses_domain_arn" {
  type = string
}
variable "ses_dkim_tokens" {
  type = list(string)
}