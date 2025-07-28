# 생성된 리포지토리의 URL 출력 (도커 CLI에서 사용됨)
output "repository_url" {
  description = "생성된 ECR 리포지토리의 URL (이미지 push/pull 용)"
  value       = aws_ecr_repository.this.repository_url
}

# 생성된 리포지토리의 ARN 출력 (IAM 정책 참조 시 유용)
output "repository_arn" {
  description = "ECR 리포지토리의 ARN (IAM 정책 등에서 사용)"
  value       = aws_ecr_repository.this.arn
}