output "repository_url" {
  description = "The URL of the created ECR repository, used for pushing/pulling images"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "The ARN of the ECR repository, useful for IAM policy references"
  value       = aws_ecr_repository.this.arn
}