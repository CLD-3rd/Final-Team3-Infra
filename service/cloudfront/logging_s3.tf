# S3 버킷 생성 시에 사용하는 구문 - CloudFront 로그 저장용 S3 버킷 생성
# resource "aws_s3_bucket" "cloudfront_log_bucket" {
#   bucket        = "${var.name_prefix}-cloudfront-logging"
#   force_destroy = false   # 버킷 비어있지 않으면 삭제 실패
#   tags = var.tags
# }

# 존재하는 S3 버킷 참조 시에 사용하는 구문
data "aws_s3_bucket" "cloudfront_log_bucket" {
  bucket = "${var.name_prefix}-cloudfront-logging"
}

# Athena 관련 로그 저장 디렉토리
resource "aws_s3_object" "athena_folder" {
  # S3 버킷 생성 시에 사용하는 구문
  # bucket = aws_s3_bucket.cloudfront_log_bucket.id
  # 존재하는 S3 버킷 참조 시에 사용하는 구문
  bucket = data.aws_s3_bucket.cloudfront_log_bucket.id

  key    = "athena-query-results/"  # 디렉토리처럼 동작
  acl    = "private"
}
# 객체 소유권 설정 - ACL 활성화를 위해 버킷 정책과 별도로 설정해야 하는 경우 사용
# 참고: Terraform AWS Provider 최신 버전에서는 aws_s3_bucket_ownership_controls 리소스로 설정 가능
resource "aws_s3_bucket_ownership_controls" "ownership" {
  # S3 버킷 생성 시에 사용하는 구문
  # bucket = aws_s3_bucket.cloudfront_log_bucket.id
  # 존재하는 S3 버킷 참조 시에 사용하는 구문
  bucket = data.aws_s3_bucket.cloudfront_log_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"  # ACL 활성화 및 버킷 소유자 권한 선호
  }
}
# 버킷 퍼블릭 액세스 차단 설정 (ACL 사용을 위해 일부 옵션 비활성화 필요)
resource "aws_s3_bucket_public_access_block" "block" {
  # S3 버킷 생성 시에 사용하는 구문
  # bucket = aws_s3_bucket.cloudfront_log_bucket.id
  # 존재하는 S3 버킷 참조 시에 사용하는 구문
  bucket = data.aws_s3_bucket.cloudfront_log_bucket.id

  block_public_acls       = false  # ACL 기반 접근 허용 위해 false
  block_public_policy     = true
  ignore_public_acls      = false  # ACL 무시하지 않음
  restrict_public_buckets = true
}
# 버킷 라이프사이클 (로그 자동 삭제)
resource "aws_s3_bucket_lifecycle_configuration" "cloudfront_log_lifecycle" {
  # S3 버킷 생성 시에 사용하는 구문
  # bucket = aws_s3_bucket.cloudfront_log_bucket.id
  # 존재하는 S3 버킷 참조 시에 사용하는 구문
  bucket = data.aws_s3_bucket.cloudfront_log_bucket.id

  rule {
    id     = "expire-cloudfront-logs"
    status = "Enabled"
    filter {}
    expiration {
      days = 30
    }
  }
}

# CloudFront 로그 버킷 정책 (CloudFront가 로그를 쓸 수 있도록 권한 부여)
resource "aws_s3_bucket_policy" "cloudfront_logs" {
  # S3 버킷 생성 시에 사용하는 구문
  # bucket = aws_s3_bucket.cloudfront_log_bucket.id
  # 존재하는 S3 버킷 참조 시에 사용하는 구문
  bucket = data.aws_s3_bucket.cloudfront_log_bucket.id

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
        # S3 버킷 생성 시에 사용하는 구문
        # Resource = "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/*"
        # 존재하는 S3 버킷 참조 시에 사용하는 구문
        Resource = "arn:aws:s3:::${data.aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/*"
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
        # S3 버킷 생성 시에 사용하는 구문
        # Resource = "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}"
        # 존재하는 S3 버킷 참조 시에 사용하는 구문
        Resource = "arn:aws:s3:::${data.aws_s3_bucket.cloudfront_log_bucket.bucket}"
      }
    ]
  })
}
# S3 Object 접근 관련 IAM역할 변수
# variable "cloudfront_log_bucket_name" {
#   type        = string
# }