variable "name_prefix" {
  type        = string
  description = "리소스 이름 접두사 (예: myapp)"
}
variable "tags" {
  type        = map(string)
  default     = {}
  description = "태그 목록"
}

# variable "environment" {
#   type        = string
#   description = "환경 구분 (예: dev, prod)"
# }

variable "engine" {
  type        = string
  default     = "mysql"
  description = "DB 엔진 (예: mysql, postgres)"
}

variable "engine_version" {
  type        = string
  default     = "8.0"
  description = "DB 엔진 버전"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS 인스턴스 타입"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "RDS 저장소 크기 (GB)"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "스토리지 타입 (standard, gp2, io1)"
}

variable "db_name" {
  type        = string
  description = "초기 생성될 DB 이름"
}

variable "username" {
  type        = string
  description = "DB 관리자 계정"
}

variable "password" {
  type        = string
  sensitive   = true
  description = "DB 비밀번호"
}

variable "parameter_group_name" {
  type        = string
  default     = "default.mysql8.0"
  description = "사용할 파라미터 그룹 이름"
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "RDS에 연결할 보안 그룹 ID 리스트"
}

variable "create_subnet_group" {
  type        = bool
  default     = true
  description = "Subnet Group을 생성할지 여부"
}

variable "private_subnet_ids" {
  type        = list(string)
  default     = []
  description = "Subnet Group 생성 시 사용할 프라이빗 서브넷 ID 리스트"
}

variable "db_subnet_group_name" {
  type        = string
  default     = null
  description = "기존 Subnet Group을 사용할 경우 이름"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "멀티 AZ 배포 여부"
}

variable "backup_retention_period" {
  type        = number
  default     = 7
  description = "백업 보존 기간"
}

variable "backup_window" {
  type        = string
  default     = "03:00-04:00"
  description = "자동 백업 시간"
}

variable "maintenance_window" {
  type        = string
  default     = "sun:04:00-sun:05:00"
  description = "유지보수 시간대"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = true
  description = "RDS 삭제 시 스냅샷 생략 여부"
}

variable "deletion_protection" {
  type        = bool
  default     = false
  description = "RDS 삭제 보호 여부"
}

variable "log_group_exists" {
  description = "이미 로그 그룹이 존재하는지 여부"
  type        = bool
  default     = false
}


# RDS 보안 그룹 생성 관련 변수
variable "create_security_group" {
  description = "RDS 용 보안 그룹을 생성할지 여부"
  type        = bool
  default     = true
}
variable "vpc_id" {
  description = "보안 그룹을 생성할 VPC ID"
  type        = string
}
variable "vpc_cidr" {
  description = "보안 그룹을 생성할 VPC cidr"
  type        = string
}
variable "rds_security_group_ids" {
  description = "외부에서 전달받을 보안 그룹 ID 목록"
  type        = list(string)
  default     = []
}
variable "vpn_security_group_id" {
  description = "VPN Security Group ID to allow SSH from"
  type        = string
}
variable "eks_node_sg_id" {
  description = "EKS 노드의 Security Group ID (RDS 접근 허용 목적)"
  type        = string
}