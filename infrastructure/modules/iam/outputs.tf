output "eks_admin_role_arn" {
  description = "생성된 EKS 관리자 IAM 역할 ARN"
  value       = aws_iam_role.eks_admin_role.arn
}

output "eks_admin_role_name" {
  description = "생성된 EKS 관리자 IAM 역할 이름"
  value       = aws_iam_role.eks_admin_role.name
}

output "admin_role_arn" {
  description = "EKS 관리자 role ARN"
  value       = aws_iam_role.eks_admin_role.arn
}
