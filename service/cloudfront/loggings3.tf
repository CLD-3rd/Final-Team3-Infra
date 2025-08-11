data "aws_iam_policy_document" "cloudfront_logs_acl" {
  statement {
    sid       = "AllowCloudFrontBucketAclUpdates"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl", "s3:PutBucketAcl"]
    resources = [aws_s3_bucket.cloudfront_log_bucket.arn]
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_policy" "cloudfront_logs_acl" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_logs_acl.json
}

# CloudFront 로그 버킷 정책 (CloudFront가 로그를 쓸 수 있도록 권한 부여)
resource "aws_s3_bucket_policy" "cloudfront_logs" {
  bucket = aws_s3_bucket.cloudfront_log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontLogsToCloudfrontBucket",
        Effect    = "Allow",
        Principal = {
          Service = "cloudfront.amazonaws.com"
        },
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl"
        ]
        Resource  = "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/*",
        Condition = {
          StringEquals = {
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
          }
        }
      }
    ]
  })
}
# S3 Object 접근 관련 IAM역할 변수
# variable "cloudfront_log_bucket_name" {
#   type        = string
# }cloudfront_bucket_name 