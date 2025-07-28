# S3 모듈 outputs.tf
# S3 버킷 ID 출력
output "bucket_id" {
  value = try(aws_s3_bucket.this[0].id, null)
}

# S3 버킷 ARN 출력
output "bucket_arn" {
  value = try(aws_s3_bucket.this[0].arn, null)
}

# S3 도메인 이름 출력 (기본 도메인)
output "bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, null)
}

# S3 리전별 도메인 출력
output "bucket_regional_domain_name" {
  description = "Regional domain name of the S3 bucket"
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, null)
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