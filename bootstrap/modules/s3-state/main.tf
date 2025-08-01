# S3 버킷 생성
resource "aws_s3_bucket" "this" {
  count          = var.create_bucket ? 1 : 0
  bucket         = var.bucket_name              # 사용자 정의 버킷 이름 (전역 고유)
  force_destroy  = var.force_destroy            # 버킷 삭제 시 객체가 남아 있으면 삭제 불가(false) 또는 강제 삭제(true)
  tags           = var.tags                     # 리소스에 공통 태그 적용
}

# 버킷 버전 관리 설정 - 객체 이력 보존 기능
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this[0].id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"  # true이면 버전 관리 활성화
  }
}

# 퍼블릭 접근 차단 설정 - 보안 강화를 위한 필수 설정
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this[0].id

  # 퍼블릭 접근 차단 - Terraform backend 용도로 필수 보안 설정
  block_public_acls       = var.block_public_acls       # 퍼블릭 ACL 차단 여부
  block_public_policy     = var.block_public_policy     # 퍼블릭 정책 차단 여부
  ignore_public_acls      = var.ignore_public_acls      # 퍼블릭 ACL 무시 여부
  restrict_public_buckets = var.restrict_public_buckets # 퍼블릭 버킷 제한 여부
}
