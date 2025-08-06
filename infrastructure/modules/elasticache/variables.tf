variable "name_prefix" {
  description = "리소스 이름 접두어"
  type        = string
}
variable "vpc_id" {
  description = "ElastiCache가 배치될 VPC ID"
  type        = string
}
variable "vpc_cidr" {
  description = "보안 그룹을 생성할 VPC cidr"
  type        = string
}
variable "private_subnet_ids" {
  description = "Redis를 배포할 프라이빗 서브넷 ID 목록"
  type        = list(string)
}
variable "eks_node_sg_id" {
  description = "EKS 노드의 Security Group ID (Redis 접근 허용 목적)"
  type        = string
}

variable "node_type" {
  description = "Redis 노드 인스턴스 타입"
  type        = string
  default     = "cache.t3.medium"   # ~ 1000명 정도, ~ 1만명 정도는 cache.m6g.large
}

variable "engine_version" {
  description = "사용할 Redis 엔진 버전"
  type        = string
  default     = "7.0"
}

variable "parameter_group_name" {
  description = "Redis 파라미터 그룹 이름"
  type        = string
  default     = "default.redis7"
}

variable "port" {
  description = "Redis 포트"
  type        = number
  default     = 6379
}

variable "automatic_failover_enabled" {
  description = "장애 발생 시 자동 Failover 활성화 여부"
  type        = bool
  default     = true
}

variable "replicas_per_node_group" {
  description = "노드 그룹당 리플리카 수 (샤딩 안 쓰면 전체 리플리카 수)"
  type        = number
  default     = 1   # Primary 1, Replica 1 = 총 노드 수 2
}

variable "auth_token" {
  description = "Redis 인증 비밀번호"
  type        = string
}

variable "maintenance_window" {
  description = "정기 유지보수 시간"
  type        = string
}

variable "snapshot_retention_limit" {
  description = "스냅샷(백업) 보관 일수"
  type        = number
}

variable "snapshot_window" {
  description = "스냅샷이 수행되는 시간대"
  type        = string
}

variable "tags" {
  description = "상위 모듈에서 전달되는 태그 정보 (default_tags)"
  type        = map(string)
}