output "cloudfront_log_bucket_name" {
  value = aws_s3_bucket.cloudfront_log_bucket.id
}

output "nlb_log_bucket_name" {
  value = aws_s3_bucket.nlb_log_bucket.id
}

output "cloudfront_log_bucket_arn" {
  value = aws_s3_bucket.cloudfront_log_bucket.arn
}

output "nlb_log_bucket_arn" {
  value = aws_s3_bucket.nlb_log_bucket.arn
}
