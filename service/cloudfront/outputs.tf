output "cloudfront_distribution_id" {
  description = "CloudFront 배포 ID"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_dns" {
  description = "CloudFront 배포 도메인 이름"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_arn" {
  description = "CloudFront 배포 ARN"
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_status" {
  description = "CloudFront 배포 상태 (Deployed/InProgress)"
  value       = aws_cloudfront_distribution.this.status
}

# Logging Bucket
# output "cloudfront_log_bucket_name" {
#   value = aws_s3_bucket.cloudfront_log_bucket.bucket
# }

# ALB
output "backend_alb_dns" {
  value = data.aws_lb.eks_alb.dns_name
}