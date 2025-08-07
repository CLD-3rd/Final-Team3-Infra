# nlb 로그 저장용 S3 버킷
resource "aws_s3_bucket" "nlb_log_bucket" {
  bucket        = var.nlb_log_bucket_name
  force_destroy = true
  tags          = var.tags
}

# Lifecycle 관리 리소스 (30일 뒤 로그 삭제)
resource "aws_s3_bucket_lifecycle_configuration" "nlb_log_lifecycle" {
  bucket = aws_s3_bucket.nlb_log_bucket.id

  rule {
    id     = "expire-nlb-logs"
    status = "Enabled"
    filter {}
    expiration {
      days = 30
    }
  }
}
