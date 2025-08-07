resource "aws_security_group" "alb_sg" {
  name        = "${var.name_prefix}-alb-sg"
  description = "Security group for ALB to allow traffic from CloudFront"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from CloudFront (0.0.0.0/0 if NLB in front)"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # 또는 CloudFront IP 대역으로 제한 가능
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}