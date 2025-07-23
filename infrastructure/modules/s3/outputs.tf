# S3 버킷 ID 출력
output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.this.id
}

# S3 버킷 ARN 출력
output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.this.arn
}

# S3 도메인 이름 출력 (기본 도메인)
output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_domain_name
}

# S3 리전별 도메인 출력
output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

# 정적 웹사이트 엔드포인트 출력 (활성화된 경우에만 유효)
output "website_endpoint" {
  description = "Website endpoint of the S3 bucket"
  value       = try(aws_s3_bucket_website_configuration.this[0].website_endpoint, null)
}

# 정적 웹사이트 도메인 출력 (활성화된 경우에만 유효)
output "website_domain" {
  description = "Website domain of the S3 bucket"
  value       = try(aws_s3_bucket_website_configuration.this[0].website_domain, null)
}