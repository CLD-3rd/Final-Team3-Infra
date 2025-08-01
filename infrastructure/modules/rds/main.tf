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
    cidr_blocks = ["0.0.0.0/0"]  # 실제 운영에서는 제한 필요!
  }
  # VPN 엔드포인트 접속 허용
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks  = ["192.168.200.0/22"]
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
  parameter_group_name   = var.parameter_group_name

  vpc_security_group_ids = var.vpc_security_group_ids
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
  # 보안그룹을 list로 받고 있는데 실제 보안그룹은 1개라 계속 업데이트가 일어남
  ignore_changes = [vpc_security_group_ids]
  }
}