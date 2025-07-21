# AWS 리전 (예: 서울 리전)
variable "aws_region" {
  description = "배포할 AWS 리전"
  default     = "ap-northeast-2"
}

# 네이밍 접두어 (예: team1 → team1-vpc 등)
variable "name_prefix" {
  description = "리소스 이름 접두어"
  default     = "team1"
}

# VPC의 CIDR 블록
variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

# 퍼블릭 서브넷 CIDR
variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷 CIDR"
  default     = "10.0.1.0/24"
}

# 프라이빗 서브넷 CIDR
variable "private_subnet_cidr" {
  description = "프라이빗 서브넷 CIDR"
  default     = "10.0.2.0/24"
}

# 가용 영역 (AZ)
variable "az" {
  description = "가용 영역"
  default     = "ap-northeast-2a"
}

# 공통 태그 (선택 사항)
variable "default_tags" {
  description = "모든 리소스에 공통으로 적용할 태그"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "cloud-team"
  }
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

# 클러스터 이름
variable "cluster_name" {
  description = "EKS 클러스터 이름"
  default     = "team1-eks"
}

# 쿠버네티스 버전 (EKS에서 지원하는 버전)
variable "kubernetes_version" {
  description = "Kubernetes 버전"
  default     = "1.27"
}

# EKS 클러스터용 IAM 역할 ARN (외부에서 생성 또는 모듈로 추출 필요)
variable "cluster_role_arn" {
  description = "EKS 클러스터에 부여할 IAM 역할 ARN"
  type        = string
}

# EKS에서 사용할 Subnet ID 목록 (보통 프라이빗 서브넷 권장)
variable "eks_subnet_ids" {
  description = "EKS 클러스터가 사용할 서브넷 ID 목록"
  type        = list(string)
}

# EKS 서비스용 CIDR (기본값: 172.20.0.0/16)
variable "service_ipv4_cidr" {
  description = "Kubernetes 서비스용 IPv4 CIDR"
  type        = string
  default     = "172.20.0.0/16"
}

# 공통 태그
variable "default_tags" {
  description = "모든 리소스에 공통으로 적용할 태그"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "cloud-team"
  }
}
