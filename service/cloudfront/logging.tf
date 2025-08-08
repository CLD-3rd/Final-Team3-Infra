# CloudFront 로그 저장용 S3 버킷
resource "aws_s3_bucket" "cloudfront_log_bucket" {
  bucket        = "${var.name_prefix}-cloudfront-logging"
  force_destroy = true

  tags = var.tags
}

# 객체 소유권 설정 - ACL 활성화를 위해 버킷 정책과 별도로 설정해야 하는 경우 사용
# 참고: Terraform AWS Provider 최신 버전에서는 aws_s3_bucket_ownership_controls 리소스로 설정 가능
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"  # ACL 활성화 및 버킷 소유자 권한 선호
  }
}

# 버킷 퍼블릭 액세스 차단 설정 (ACL 사용을 위해 일부 옵션 비활성화 필요)
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  block_public_acls       = false  # ACL 기반 접근 허용 위해 false
  block_public_policy     = true
  ignore_public_acls      = false  # ACL 무시하지 않음
  restrict_public_buckets = true
}

# 버킷 라이프사이클 (로그 자동 삭제)
resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_log_lifecycle" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  rule {
    id     = "expire-cloudfront-logs"
    status = "Enabled"
    filter {}

    expiration {
      days = 30
    }
  }
}