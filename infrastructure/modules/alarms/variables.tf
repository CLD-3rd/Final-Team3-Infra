variable "name_prefix" {
  description = "리소스 이름 접두어"
  type        = string
}
variable "tags" {
  description = "상위 모듈에서 전달되는 태그 정보 (default_tags)"
  type        = map(string)
}

# CloudWatch Alert
variable "sns_topic_arn" {
  type        = string
  description = "SNS topic ARN for CloudWatch alarms"
}

variable "redis_replica_group_id" {
  type        = string
  description = "ElastiCache Redis Replication Group ID"
}

variable "rds_instance_id" {
  type        = string
  description = "RDS 인스턴스 ID"
}

variable "nat_gateway_id" {
  type        = string
  description = "NAT Gateway ID"
}