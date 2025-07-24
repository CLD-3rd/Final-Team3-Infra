output "redis_primary_endpoint" {
  description = "Redis 기본(primary) 엔드포인트(쓰기용)"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Redis 읽기 전용(reader) 엔드포인트(리플리카 연결용)"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_port" {
  description = "Redis 서비스 포트 번호"
  value       = aws_elasticache_replication_group.this.port
}