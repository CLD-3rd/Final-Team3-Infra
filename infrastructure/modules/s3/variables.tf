# S3 버킷 이름 (필수, 전역 고유)
variable "bucket_name" {
  description = "Name of the S3 bucket (must be globally unique)"
  type        = string
}

# 버전 관리 활성화 여부
variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

# 정적 웹사이트 호스팅 활성화 여부
variable "enable_website" {
  description = "Enable static website hosting"
  type        = bool
  default     = false
}

# 인덱스 문서 파일 이름
variable "index_document" {
  description = "Index document for static website"
  type        = string
  default     = "index.html"
}

# 에러 문서 파일 이름
variable "error_document" {
  description = "Error document for static website"
  type        = string
  default     = "error.html"
}

# 퍼블릭 접근 차단 설정 (보안)
variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

# 퍼블릭 버킷 정책 차단 여부
# true로 설정하면 퍼블릭 접근을 허용하는 S3 버킷 정책을 적용하지 못하게 차단합니다.
variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

# 퍼블릭 ACL 무시 여부
# true로 설정하면 퍼블릭으로 설정된 ACL(Access Control List)을 무시합니다.
# 즉, 누가 퍼블릭 읽기/쓰기 권한을 부여해도 무시됩니다.
variable "ignore_public_acls" {
  description = "Ignore any public ACLs"
  type        = bool
  default     = true
}

# 퍼블릭 접근 자체 제한 여부
# true로 설정하면 버킷과 객체 모두 퍼블릭 접근이 완전히 제한됩니다.
# (퍼블릭 정책 또는 퍼블릭 ACL이 있어도 접근 불가)
variable "restrict_public_buckets" {
  description = "Restrict public access to the bucket"
  type        = bool
  default     = true
}

# 버킷 정책 (JSON 객체 형태)
variable "bucket_policy" {
  description = "Optional JSON object representing the bucket policy"
  type        = any
  default     = null
}

# 공통 태그
variable "tags" {
  description = "Tags to apply to the S3 bucket"
  type        = map(string)
  default     = {}
}