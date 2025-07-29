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