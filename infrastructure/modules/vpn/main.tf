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
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "vpn_logging_role" {
  name = "${var.name_prefix}-vpn-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "clientvpn.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "vpn_logging_policy" {
  name = "${var.name_prefix}-vpn-logging-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "vpn_logging_attach" {
  role       = aws_iam_role.vpn_logging_role.name
  policy_arn = aws_iam_policy.vpn_logging_policy.arn
}

resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "${var.name_prefix}-vpn"
  vpc_id                 = var.vpc_id
  client_cidr_block      = var.client_cidr_block
  server_certificate_arn = var.server_certificate_arn

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_ca_certificate_arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = var.cloudwatch_log_group
  }

  dns_servers        = ["8.8.8.8"]
  transport_protocol = "udp"
  split_tunnel       = true
  security_group_ids = [
    var.create_security_group ? aws_security_group.vpn_sg[0].id : var.security_group_id
  ]

  tags = {
    Name = "${var.name_prefix}-vpn"
  }
}