# MatchFit VPC 모듈 variables.tf

# 리소스 이름에 접두어로 사용할 값 (예: team1 → team1-vpc)
variable "name_prefix" {
  description = "리소스 이름에 공통적으로 사용할 접두어"
  type        = string
}

# VPC의 CIDR 블록 (예: 10.0.0.0/16)
variable "vpc_cidr" {
  description = "VPC의 IP 주소 범위 (CIDR)"
  type        = string
}

# 사용할 가용 영역 (AZ) (예: ap-northeast-2a)
variable "az" {
  description = "서브넷을 생성할 AWS 가용 영역"
  type        = list(string)
}

# 퍼블릭 서브넷의 CIDR 블록 (예: 10.0.1.0/24)
variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷의 CIDR 블록"
  type        = list(string)
}

# 프라이빗 서브넷의 CIDR 블록 (예: 10.0.2.0/24)
variable "private_subnet_cidr" {
  description = "프라이빗 서브넷의 CIDR 블록"
  type        = list(string)
}

# 다중 라우팅 테이블 정의 (동적 생성에 사용)
variable "route_tables" {
  description = <<EOF
라우팅 테이블 리스트. 각 항목은 다음 속성 포함:
- name: 태그용 이름
- tags: 태그 맵
- routes: 라우팅 규칙 리스트 (cidr_block, gateway_id, nat_gateway_id)
- subnet_ids: 연결할 서브넷 ID 리스트
EOF

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
}

# IGW 및 라우팅 테이블 생성을 위한 VPC ID (모듈 외부에서 참조 가능하도록 따로 받음)
variable "vpc_id" {
  description = "라우팅 테이블이나 IGW에 연결할 외부 VPC ID"
  type        = string
}

# IGW에 사용할 태그 정보
variable "tags" {
  description = "공통 리소스 태그"
  type        = map(string)
  default     = {}
}

# IGW 이름 태그
variable "name" {
  description = "인터넷 게이트웨이 이름 태그 값"
  type        = string
}
