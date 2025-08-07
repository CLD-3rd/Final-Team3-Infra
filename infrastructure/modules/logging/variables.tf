variable "name_prefix" {
  description = "리소스 이름에 공통적으로 사용할 접두어"
  type        = string
}

variable "nlb_name" {
  description = "NLB 이름"
  type        = string
}

variable "public_subnet_ids" {
  description = "퍼블릭 서브넷 ID 목록"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
}
