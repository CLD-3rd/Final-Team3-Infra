variable "name_prefix" {
  description = "리소스 이름에 공통적으로 사용할 접두어"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
}
