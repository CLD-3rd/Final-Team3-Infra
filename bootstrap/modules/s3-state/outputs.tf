# S3 버킷 ID 출력
output "bucket_id" {
  description = "S3 버킷의 고유 ID"
  value = try(aws_s3_bucket.this[0].id, null)
}

# S3 버킷 ARN 출력
output "bucket_arn" {
  description = "S3 버킷의 Amazon Resource Name"
  value = try(aws_s3_bucket.this[0].arn, null)
}

# S3 도메인 이름 출력 (기본 도메인)
output "bucket_domain_name" {
  description = "S3 버킷의 기본 도메인 이름"
  value       = try(aws_s3_bucket.this[0].bucket_domain_name, null)
}

# S3 리전별 도메인 출력
output "bucket_regional_domain_name" {
  description = "리전 기반 S3 도메인 이름"
  value       = try(aws_s3_bucket.this[0].bucket_regional_domain_name, null)
}
