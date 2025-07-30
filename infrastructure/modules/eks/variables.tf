variable "cluster_name" {
  type = string
}
variable "kubernetes_version" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "service_ipv4_cidr" {
  default = "172.20.0.0/16"
}

variable "ssh_key_name" {
  type        = string
  description = "EC2 SSH key pair name for remote access"
}

variable "tags" {
  type = map(string)
}

variable "worker_access_cidr" {
  description = "Node → API 서버 허용 CIDR"
  type = list(string)
}

variable "create_instance_profile" {
  description = "EC2 IAM 역할 연결 관련 Profile을 생성할지 여부"
  type        = bool
  default     = true
}

variable "oidc_thumbprint" {
  description = "OIDC 공급자의 thumbprint (IRSA용)"
  default = "9e99a48a9960b14926bb7f3b02e22da0afd40bd7"
}

variable "vpn_security_group_id" {
  type        = string
  description = "VPN Security Group ID to allow SSH from"
}

# aws_auth.tf 관련 변수
# variable "node_role_arn" {
#   description = "EKS Node IAM Role ARN"
#   type        = string
# }
# variable "admin_role_arn" {
#   description = "EKS Admin IAM Role ARN"
#   type        = string
# }
# variable "admin_user_arn" {
#   description = "EKS Admin IAM User ARN"
#   type        = string
# }