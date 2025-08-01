# AWS 리전
variable "aws_region" {
  description = "리소스를 생성할 AWS 리전"
  default     = "ap-northeast-2"
}

# 공통 태그
variable "default_tags" {
  description = "모든 리소스에 공통으로 적용할 태그"
  type        = map(string)
  default = {
    Environment = "dev"
    Owner       = "matchfit"
  }
}

#####################
# S3 관련 루트 변수
variable "create_bucket" {
  description = "S3 버킷을 생성할지 여부 (조건적 사용 시 true)"
  type        = bool
  default = true
}
variable "bucket_name" {
  description = "Terraform 상태 파일 저장용 S3 버킷 이름 (전역 고유)"
  type        = string
  default     = "matchfit-terraform-loc"
}
variable "enable_versioning" {
  description = "S3 버전 관리 활성화 여부"
  type        = bool
  default     = true
}
variable "block_public_acls" {
  description = "퍼블릭 ACL 차단 여부"
  type        = bool
  default     = true
}
variable "block_public_policy" {
  description = "퍼블릭 정책 차단 여부"
  type        = bool
  default     = true
}
variable "ignore_public_acls" {
  description = "퍼블릭 ACL 무시 여부"
  type        = bool
  default     = true
}
variable "restrict_public_buckets" {
  description = "퍼블릭 버킷 접근 제한 여부"
  type        = bool
  default     = true
}
variable "force_destroy" {
  description = "버킷 삭제 시 객체도 함께 삭제할지 여부"
  type        = bool
  default     = false
}

#####################
# DynamoDB 관련 루트 변수
variable "dynamodb_table_name" {
  description = "Terraform 상태 잠금을 위한 DynamoDB 테이블 이름"
  type        = string
  default     = "matchfit-terraform-lock-table"
}