output "cloudfront_distribution_id" {
  description = "CloudFront 배포 ID"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_domain_name" {
  description = "CloudFront 도메인 이름"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "nlb_dns_name" {
  description = "NLB DNS 이름"
  value       = aws_lb.nlb.dns_name
}

output "cloudfront_log_bucket_name" {
  description = "CloudFront 로그 저장용 S3 버킷 이름"
  value       = aws_s3_bucket.cloudfront_log_bucket.id
}

output "nlb_log_bucket_name" {
  description = "NLB 로그 저장용 S3 버킷 이름"
  value       = aws_s3_bucket.nlb_log_bucket.id
}

output "cloudfront_log_bucket_domain_name" {
  description = "CloudFront 로그 저장용 버킷의 도메인 이름"
  value       = aws_s3_bucket.cloudfront_log_bucket.bucket_domain_name
}

output "nlb_log_bucket_domain_name" {
  description = "NLB 로그 저장용 버킷의 도메인 이름"
  value       = aws_s3_bucket.nlb_log_bucket.bucket_domain_name
}

output "cloudfront_log_bucket_arn" {
  description = "CloudFront 로그 저장용 S3 버킷 ARN"
  value       = aws_s3_bucket.cloudfront_log_bucket.arn
}

output "nlb_log_bucket_arn" {
  description = "NLB 로그 저장용 S3 버킷 ARN"
  value       = aws_s3_bucket.nlb_log_bucket.arn
}
