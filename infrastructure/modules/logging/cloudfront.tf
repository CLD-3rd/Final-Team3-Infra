# CloudFront 로그 저장용 S3 버킷
resource "aws_s3_bucket" "cloudfront_log_bucket" {
  bucket        = var.cloudfront_log_bucket_name
  force_destroy = true
  tags          = var.tags
}

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
