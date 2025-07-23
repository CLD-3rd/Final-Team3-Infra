output "rds_identifier" {
  description = "RDS 인스턴스 식별자"
  value       = aws_db_instance.this.id
}

output "rds_endpoint" {
  description = "RDS 접속 엔드포인트"
  value       = aws_db_instance.this.endpoint
  sensitive   = true
}

output "rds_port" {
  description = "RDS 포트 번호"
  value       = aws_db_instance.this.port
}

output "rds_address" {
  description = "RDS 호스트 이름"
  value       = aws_db_instance.this.address
  sensitive   = true
}

output "rds_arn" {
  description = "RDS 인스턴스 ARN"
  value       = aws_db_instance.this.arn
}

output "rds_security_group_id" {
  description = "RDS 보안 그룹 ID"
  value       = var.create_security_group ? aws_security_group.rds[0].id : null
}