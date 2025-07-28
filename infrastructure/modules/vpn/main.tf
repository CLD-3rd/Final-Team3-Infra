resource "aws_security_group" "vpn_sg" {
  count  = var.create_security_group ? 1 : 0
  name   = "${var.name_prefix}-vpn-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.200.0/22"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description               = "${var.name_prefix} VPN"
  client_cidr_block         = var.client_cidr_block
  server_certificate_arn    = var.server_certificate_arn
  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_ca_certificate_arn
  }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = var.cloudwatch_log_group
    cloudwatch_log_stream = var.cloudwatch_log_stream
  }

  dns_servers       = ["8.8.8.8"]
  transport_protocol = "udp"
  split_tunnel       = true
  security_group_ids = [
    var.create_security_group ? aws_security_group.vpn_sg[0].id : var.security_group_id
  ]
  tags = {
    Name = "${var.name_prefix}-vpn"
  }
}

resource "aws_ec2_client_vpn_network_association" "associations" {
  for_each = toset(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_route" "route_to_vpc" {
  for_each = toset(var.subnet_ids)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  destination_cidr_block = "100.0.0.0/16"
  target_vpc_subnet_id   = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "allow_all" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_network_cidr    = "100.0.0.0/16"
  authorize_all_groups   = true
}