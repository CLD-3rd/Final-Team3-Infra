output "alb_controller_irsa_role_arn" {
  description = "ALB Controller가 사용할 IAM 역할의 ARN (IRSA 역할)"
  value       = aws_iam_role.alb_controller_irsa.arn
}
