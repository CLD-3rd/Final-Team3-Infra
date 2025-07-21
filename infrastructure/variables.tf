# AWS 리전
variable "aws_region" {
  description = "AWS 리전 (예: ap-northeast-2)"
  type        = string
}

# 리소스 이름 접두어
variable "name_prefix" {
  description = "리소스에 공통적으로 사용할 접두어"
  type        = string
}

# VPC CIDR
variable "vpc_cidr" {
  description = "VPC의 IP 주소 범위 (CIDR)"
  type        = string
}

# 퍼블릭 서브넷 CIDR
variable "public_subnet_cidr" {
  description = "퍼블릭 서브넷의 CIDR 범위"
  type        = string
}

# 프라이빗 서브넷 CIDR
variable "private_subnet_cidr" {
  description = "프라이빗 서브넷의 CIDR 범위"
  type        = string
}

# 가용 영역 (AZ)
variable "az" {
  description = "사용할 AWS 가용 영역 (예: ap-northeast-2a)"
  type        = string
}

# 공통 태그
variable "tags" {
  description = "모든 리소스에 공통으로 적용할 태그"
  type        = map(string)
}
