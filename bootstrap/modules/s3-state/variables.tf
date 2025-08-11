variable "bucket_name" {
  description = "전역적으로 유일한 S3 버킷 이름"
  type        = string
}

variable "force_destroy" {
  description = "버킷 삭제 시 객체도 함께 삭제할지 여부"
  type        = bool
}

variable "enable_versioning" {
  description = "S3 버킷 버전 관리 활성화 여부"
  type        = bool
}

variable "block_public_acls" {
  description = "퍼블릭 ACL 차단 여부"
  type        = bool
}

variable "block_public_policy" {
  description = "퍼블릭 정책 차단 여부"
  type        = bool
}

variable "ignore_public_acls" {
  description = "퍼블릭 ACL 무시 여부"
  type        = bool
}

variable "restrict_public_buckets" {
  description = "퍼블릭 버킷 접근 제한 여부"
  type        = bool
}

variable "tags" {
  description = "S3에 적용할 공통 태그"
  type        = map(string)
}

variable "create_bucket" {
  description = "S3 버킷을 생성할지 여부 (조건적 사용 시 true)"
  type        = bool
}
