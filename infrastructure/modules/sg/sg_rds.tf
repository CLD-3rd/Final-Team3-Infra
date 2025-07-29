# RDS 관련 Security Group
resource "aws_security_group" "rds" {
  count  = var.create_security_group ? 1 : 0
  name   = "${var.name_prefix}-rds-sg"
  vpc_id = var.vpc_id
  description = "Security group for RDS instance"
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # 실제 운영에서는 제한 필요!
  }
  # VPN 엔드포인트 접속 허용
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = var.create_security_group ? [aws_security_group.vpn_sg[0].id] : [var.security_group_id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name_prefix}-rds-sg"
  }
}