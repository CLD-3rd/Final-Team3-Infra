output "client_vpn_endpoint_id" {
  value       = aws_ec2_client_vpn_endpoint.vpn.id
  description = "생성된 Client VPN 엔드포인트 ID"
}

output "client_vpn_endpoint_dns" {
  value = aws_ec2_client_vpn_endpoint.vpn.dns_name
}

output "client_vpn_endpoint_arn" {
  value       = aws_ec2_client_vpn_endpoint.vpn.arn
  description = "생성된 Client VPN 엔드포인트 ARN"
}

output "vpn_security_group_id" {
  value       = var.create_security_group ? aws_security_group.vpn_sg[0].id : var.security_group_id
  description = "VPN 보안 그룹 ID"
}

output "vpn_logging_role_arn" {
  value       = aws_iam_role.vpn_logging_role.arn
  description = "VPN CloudWatch 로그용 IAM 역할 ARN"
}