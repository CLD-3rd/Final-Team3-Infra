# 기본 설정
variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-northeast-2"
}

variable "name_prefix" {
  description = "리소스 이름 접두사"
  type        = string
}

variable "environment" {
  description = "환경 구분 (예: dev, prod)"
  type        = string
}

# 네트워크
variable "vpc_cidr" {
  description = "VPC의 CIDR 블록"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷들의 CIDR 리스트"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "프라이빗 서브넷들의 CIDR 리스트"
  type        = list(string)
}

variable "az" {
  description = "사용할 가용 영역(Availability Zones) 리스트"
  type        = list(string)
}

variable "default_tags" {
  description = "모든 리소스에 적용할 기본 태그 맵"
  type        = map(string)
  default     = {
    Environment = "dev"
    Owner       = "cloud-team"
  }
}

# 라우팅 테이블
variable "route_tables" {
  description = "커스텀 라우팅 테이블 정의 목록"
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
  default = []
}

# EKS 관련
variable "kubernetes_version" {
  description = "사용할 Kubernetes 버전"
  type        = string
  default     = "1.27"
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
  default     = "team3-eks"
}

variable "service_ipv4_cidr" {
  description = "Kubernetes 서비스 네트워크 CIDR"
  type        = string
  default     = "172.20.0.0/16"
}

variable "ssh_key_name" {
  description = "EKS 워커 노드의 SSH 키 페어 이름"
  type        = string
}

variable "worker_access_cidr" {
  description = "EKS API에 접근을 허용할 CIDR 리스트"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}


# RDS 관련
variable "db_name" {
  description = "RDS에 생성할 초기 데이터베이스 이름"
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
}
variable "rds_private_subnet_ids" {
  description = "RDS 인스턴스가 위치할 프라이빗 서브넷 ID 리스트"
  type        = list(string)
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
  default     = false
}
variable "deletion_protection" {
  description = "RDS 삭제 보호 기능 활성화 여부"
  type        = bool
  default     = true
}
