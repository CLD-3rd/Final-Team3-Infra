output "ca_irsa_role_arn" {
  description = "Cluster Autoscaler IRSA용 IAM 역할 ARN"
  value       = aws_iam_role.ca_irsa.arn
}