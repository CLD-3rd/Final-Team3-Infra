# AWS 리전 (예: 서울 리전)
variable "aws_region" {
  description = "배포할 AWS 리전"
  default     = "ap-northeast-2"
}
# 네이밍 접두어 (예: team1 → team1-vpc 등)
variable "name_prefix" {
  description = "리소스 이름 접두어"
  default     = "team3"
}
# 공통 태그 (선택 사항)
variable "default_tags" {
  description = "모든 리소스에 공통으로 적용할 태그"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "matchfit"
  }
}


# VPC의 CIDR 블록
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}
# 퍼블릭 서브넷 CIDR
variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷 CIDR"
  default     = "10.0.10.0/24"
}
# 프라이빗 서브넷 CIDR
variable "private_subnet_cidr" {
  description = "프라이빗 서브넷 CIDR"
  default     = "10.0.1.0/24"
}
# 가용 영역 (AZ)
variable "az" {
  description = "가용 영역"
  default     = "ap-northeast-2a"
}
# 라우팅 테이블 정의 리스트
variable "route_tables" {
  description = "라우팅 테이블 설정 (이름, 라우트, 서브넷 연결 등)"
  type = list(object({
    name       = string
    tags       = map(string)
    routes     = list(object({
      cidr_block     = string
      gateway_id     = optional(string)
      nat_gateway_id = optional(string)
    }))
    subnet_ids = list(string)
  }))

  default = []  # 테스트용으로는 비워 둘 수도 있음
}


# EKS 관련 루트 variables
variable "kubernetes_version" {
  default = "1.32"
}
variable "cluster_name" {
  default = "matchfit-eks"
}
variable "service_ipv4_cidr" {
  description = "Kubernetes 서비스 네트워크 CIDR"
  type        = string
  default     = "172.20.0.0/16"
}
variable "worker_access_cidr" {
  description = "EKS API 접근 허용 CIDR"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "ssh_key_name" {
  description = "EC2 인스턴스에 사용할 SSH 키 이름"
  type        = string
}

variable "db_name" {
  description = "RDS 데이터베이스 이름"
  type        = string
}

# S3 관련 변수들
variable "bucket_name" {
  description = "Name of the S3 bucket (globally unique)"
  type        = string
}
variable "db_username" {
  description = "데이터베이스 관리자 사용자 이름"
  type        = string
}
variable "db_password" {
  description = "데이터베이스 비밀번호 (보안상 민감 정보)"
  type        = string
  sensitive   = true
}
variable "rds_security_group_ids" {
  description = "RDS에 적용할 보안 그룹 ID 목록"
  type        = list(string)
  default     = []
}
variable "create_subnet_group" {
  description = "서브넷 그룹 생성 여부"
  type        = bool
  default     = true
}
variable "db_subnet_group_name" {
  description = "기존에 생성된 서브넷 그룹 이름 (사용 시 지정)"
  type        = string
  default     = null
}
variable "multi_az" {
  description = "멀티 AZ 배포 여부"
  type        = bool
  default     = true
}
variable "backup_retention_period" {
  description = "자동 백업 보존 기간(일 단위)"
  type        = number
  default     = 7
}
variable "backup_window" {
  description = "자동 백업 수행 시간 (예: 03:00-04:00)"
  type        = string
  default     = "03:00-04:00"
}
variable "maintenance_window" {
  description = "유지보수 작업 허용 시간대 (예: sun:04:00-sun:05:00)"
  type        = string
  default     = "sun:04:00-sun:05:00"
}
variable "skip_final_snapshot" {
  description = "RDS 삭제 시 최종 스냅샷 생성 여부 (true 시 생략)"
  type        = bool
  default     = true
}
variable "deletion_protection" {
  description = "RDS 삭제 보호 기능 활성화 여부"
  type        = bool
  default     = true
}

# S3 관련 설정
variable "bucket_name" {
  type        = string
  description = "S3 Bucket name (globally unique)"
}

variable "enable_versioning" {
  type        = bool
  default     = false
}

variable "enable_website" {
  type        = bool
  default     = false
}

variable "index_document" {
  type        = string
  default     = "index.html"
}

variable "error_document" {
  type        = string
  default     = "error.html"
}

variable "block_public_acls" {
  type        = bool
  default     = true
}

variable "block_public_policy" {
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  type        = bool
  default     = true
}

variable "bucket_policy" {
  description = "Optional S3 Bucket policy as JSON object"
  type        = any
  default     = null
}

variable "force_destroy" {
  description = "S3 버킷 삭제 시 객체까지 함께 삭제할지 여부"
  type        = bool
  default     = false
}
