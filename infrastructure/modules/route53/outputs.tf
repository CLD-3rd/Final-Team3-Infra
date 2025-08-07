# output "hosting_zone_id" {
#   description = "DNS 생성용 OUTPUT"
#   value = aws_route53_zone.primary.zone_id
# }
output "domain_name" {
  description = "Route53 hosted zone domain name"
  value       = data.aws_route53_zone.primary.name
}
output "hosting_zone_id" {
  description = "생성된 Route53 호스팅 존의 Zone ID"
  value       = data.aws_route53_zone.primary.zone_id
}