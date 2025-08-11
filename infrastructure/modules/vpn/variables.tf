variable "name_prefix" {
  type        = string
  description = "리소스 이름 접두사"
}

variable "vpc_id" {
  type        = string
  description = "VPN을 생성할 VPC ID"
}
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR (VPN 라우팅용)"
}
variable "client_cidr_block" {
  type        = string
  description = "VPN 클라이언트 IP 풀 CIDR (예: 192.168.200.0/22)"
}

variable "server_certificate_arn" {
  type        = string
  description = "서버 인증서 ARN"
}

variable "client_ca_certificate_arn" {
  type        = string
  description = "클라이언트 CA 인증서 ARN"
}

variable "cloudwatch_log_group" {
  type        = string
  description = "CloudWatch 로그 그룹 이름"
}

variable "subnet_ids" {
  type        = list(string)
  description = "VPN 네트워크 어소시에이션용 서브넷 ID 리스트"
}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "기존 보안 그룹 ID (create_security_group가 false일 때 사용)"
  validation {
    condition     = var.create_security_group || (length(var.security_group_id) > 0)
    error_message = "create_security_group이 false인 경우, security_group_id는 필수입니다."
  }
}

variable "create_security_group" {
  type        = bool
  default     = true
  description = "VPN 보안 그룹 생성 여부"
}