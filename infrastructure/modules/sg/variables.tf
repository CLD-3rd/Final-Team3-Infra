### SG(보안그룹) 생성 관련 모듈화 virables.tf ###
variable "name_prefix" {
  type        = string
  description = "리소스 이름 접두사 (예: myapp)"
}
variable "tags" {
  type    = map(string)
  default = {}
}
#####################
# EKS 관련 Security Group (클러스터, 노드그룹)
variable "vpc_id" {
  type        = string
  description = "VPC ID where SG will be created"
}
variable "worker_access_cidr" {
  type        = list(string)
  description = "CIDR blocks for worker nodes to access control plane"
}
#####################
# VPN 관련 Security Group
variable "security_group_id" {
  type        = string
  default     = ""
  description = "기존 보안 그룹 ID (create_security_group가 false일 때 사용)"
  validation {
    condition     = var.create_security_group || (length(var.security_group_id) > 0)
    error_message = "create_security_group이 false인 경우, security_group_id는 필수입니다."
  }
}
#####################
# RDS 관련 Security Group
# variable "private_subnet_ids" {
#   type        = list(string)
#   default     = []
#   description = "Subnet Group 생성 시 사용할 프라이빗 서브넷 ID 리스트"
# }
# # RDS 보안 그룹 생성 관련 변수
# variable "create_security_group" {
#   description = "RDS 용 보안 그룹을 생성할지 여부"
#   type        = bool
#   default     = true
# }
# variable "vpc_id" {
#   description = "보안 그룹을 생성할 VPC ID"
#   type        = string
# }
# variable "rds_security_group_ids" {
#   description = "외부에서 전달받을 보안 그룹 ID 목록"
#   type        = list(string)
#   default     = []
# }