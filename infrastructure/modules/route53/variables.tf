variable "domain_name" {
  description = "Route53에 등록할 최상위 도메인 이름"
  type        = string
}

variable "argocd_alb_dns" {
  description = "ArgoCD ALB DNS 이름"
  type        = string
}

variable "cloudfront_dns" {
  description = "CloudFront DNS 이름"
  type        = string
}