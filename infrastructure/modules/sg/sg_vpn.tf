# VPN 관련 Security Group
resource "aws_security_group" "vpn_sg" {
  count  = var.create_security_group ? 1 : 0
  name   = "${var.name_prefix}-eks-vpn-sg"
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
  tags = merge({ Name = "${var.name_prefix}-eks-node-sg" }, var.tags)
}