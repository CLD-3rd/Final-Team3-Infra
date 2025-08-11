# CloudFront 로그 버킷 정책 (CloudFront가 로그를 쓸 수 있도록 권한 부여)
resource "aws_s3_bucket_policy" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # PutObject 권한 - 객체 리소스 대상
      {
        Sid = "AllowCloudFrontPutObject"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/*"
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      },

      # ACL 관련 권한 - 버킷 리소스 대상
      {
        Sid = "AllowCloudFrontBucketAcl"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetBucketAcl",
          "s3:PutBucketAcl"
        ]
        Resource = "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}"
      }
    ]
  })
}
# S3 Object 접근 관련 IAM역할 변수
# variable "cloudfront_log_bucket_name" {
#   type        = string
# }