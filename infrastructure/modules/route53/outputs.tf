output "hosting_zone_id" {
  description = "생성된 Route53 호스팅 존의 Zone ID"
  value       = data.aws_route53_zone.primary.zone_id
}

output "alb_dns_name" {
  value = var.argocd_alb_dns
}