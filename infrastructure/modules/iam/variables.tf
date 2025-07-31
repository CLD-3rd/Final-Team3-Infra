variable "name_prefix" {
  description = "리소스 이름 접두어"
  type        = string
}
variable "admin_user_arn" {
  description = "관리자 IAM 사용자의 ARN"
  type        = string
}

variable "tags" {
  description = "상위 모듈에서 전달되는 태그 정보 (default_tags)"
  type        = map(string)
}

# VPN Logging 관련 IAM역할 변수
variable "create_vpn_logging_role" {
  type        = bool
  description = "이미 존재하는 vpn logging role을 사용하지 않고 새로 생성할지 여부"
  default     = false
}

variable "create_vpn_logging_policy" {
  type        = bool
  description = "이미 존재하는 vpn logging policy를 사용하지 않고 새로 생성할지 여부"
  default     = false
}