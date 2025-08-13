variable "name_prefix" {
  description = "리소스 이름 접두어"
  type        = string
}
variable "tags" {
  description = "상위 모듈에서 전달되는 태그 정보 (default_tags)"
  type        = map(string)
}
# variable "subscriptions" {
#   description = "List of email addresses to subscribe to SNS topic"
#   type        = list(string)
#   default     = []
# }