#####################
# S3 루트 출력
output "s3_bucket_id" {
  description = "The ID of the created S3 bucket"
  value       = module.s3_bucket.bucket_id
}
output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = module.s3_bucket.bucket_arn
}
output "s3_bucket_domain" {
  description = "The domain name of the created S3 bucket"
  value       = module.s3_bucket.bucket_domain_name
}
output "s3_bucket_regional_domain" {
  description = "The regional domain name of the bucket"
  value       = module.s3_bucket.bucket_regional_domain_name
}

#####################
# DynamoDB 출력
output "dynamodb_table_name" {
  value       = module.dynamodb.table_name
  description = "Terraform lock을 위한 DynamoDB 테이블 이름"
}