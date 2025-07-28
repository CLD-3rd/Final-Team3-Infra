output "client_vpn_endpoint_id" {
  value = aws_ec2_client_vpn_endpoint.vpn.id
}

output "client_vpn_endpoint_dns" {
  value = aws_ec2_client_vpn_endpoint.vpn.dns_name
}