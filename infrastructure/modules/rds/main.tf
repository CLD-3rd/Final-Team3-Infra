# RDS Subnet Group 생성 (조건부)
resource "aws_db_subnet_group" "this" {
  count = var.create_subnet_group ? 1 : 0

  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags =  {
    Name = "${var.name_prefix}-subnet-group"
  }
}

# RDS 보안그룹 생성
resource "aws_security_group" "rds" {
  count  = var.create_security_group ? 1 : 0
  name   = "${var.name_prefix}-rds-sg"
  vpc_id = var.vpc_id

  description = "Security group for RDS instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  # VPN 엔드포인트 접속 허용
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.vpn_security_group_id]
  }
  # EKS 노드로부터 RDS에 대한 접근 허용
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [var.eks_node_sg_id]
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


# RDS 인스턴스 생성
resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-rds"
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  storage_type           = var.storage_type
  storage_encrypted      = true

  db_name                = var.db_name
  username               = var.username
  password               = var.password
  parameter_group_name   =  aws_db_parameter_group.rds_logs.name
  # logging
  enabled_cloudwatch_logs_exports = ["general", "slowquery", "error"]

  # vpc_security_group_ids = var.vpc_security_group_ids
  vpc_security_group_ids = var.create_security_group ? [aws_security_group.rds[0].id] : var.vpc_security_group_ids
  db_subnet_group_name   = var.create_subnet_group ? aws_db_subnet_group.this[0].name : var.db_subnet_group_name

  multi_az               = var.multi_az
  publicly_accessible    = false

  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = var.deletion_protection

  tags = {
    Name = "${var.name_prefix}-rds"
  }

  lifecycle {
  # prevent_destroy = true # 삭제 막기
    ignore_changes = [
      password,
      backup_window,
      maintenance_window
    ]
  }
}