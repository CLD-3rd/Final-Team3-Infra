# RDS Subnet Group 생성 (조건부)
resource "aws_db_subnet_group" "this" {
  count = var.create_subnet_group ? 1 : 0

  name       = "${var.name_prefix}-${var.environment}-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags =  {
    Name = "${var.name_prefix}-${var.environment}-subnet-group"
  }
}

# RDS 인스턴스 생성
resource "aws_db_instance" "this" {
  identifier             = "${var.name_prefix}-${var.environment}-rds"
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
    Name = "${var.name_prefix}-${var.environment}-rds"
  }
}
