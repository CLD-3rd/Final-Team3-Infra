variable "cloudfront_log_bucket_name" {
  description = "CloudFront 로그 저장용 S3 버킷 이름"
  type        = string
}

variable "nlb_log_bucket_name" {
  description = "NLB 로그 저장용 S3 버킷 이름"
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
