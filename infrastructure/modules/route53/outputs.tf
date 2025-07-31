output "zone_id" {
  description = "생성된 Route53 호스팅 존의 Zone ID"
  value       = aws_route53_zone.primary.zone_id
}