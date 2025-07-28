output "alb_controller_irsa_role_arn" {
  description = "ALB Controller가 사용할 IAM Role의 ARN (IRSA)"
  value = aws_iam_role.alb_controller_irsa.arn
}
