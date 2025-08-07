variable "service_name" {
  description = "서비스 이름 (OAC 리소스 네이밍)"
  type        = string
}

variable "domain_name" {
  description = "CloudFront에 연결할 도메인"
  type        = string
}

variable "cloudfront_certificate_arn" {
  description = "ACM 인증서 ARN (us-east-1)"
  type        = string
}

variable "s3_origin_domain" {
  description = "CloudFront 오리진으로 사용할 S3 버킷 도메인"
  type        = string
}

variable "s3_bucket_id" {
  description = "정책 적용 대상 S3 버킷 ID"
  type        = string
}

variable "s3_bucket_arn" {
  description = "정책 적용 대상 S3 버킷 ARN"
  type        = string
}

variable "origin_id" {
  description = "CloudFront 오리진 ID"
  type        = string
  default     = "s3-origin"
}

variable "price_class" {
  description = "CloudFront 가격 클래스"
  type        = string
  default     = "PriceClass_200"
}

variable "custom_error_responses" {
  description = "커스텀 에러 페이지 설정"
  type = list(object({
    error_code         = number
    response_code      = number
    response_page_path = string
  }))
  default = []
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}