resource "aws_iam_role" "alb_controller_irsa" {
  name = "${var.cluster_name}-alb-irsa-role"

  # OIDC 기반 AssumeRole 정책 정의 (IRSA 용도)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn         # OIDC Provider (EKS에서 제공)
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          # 특정 서비스 계정에만 역할 부여 (kube-system 네임스페이스)
          "${replace(var.oidc_provider_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })

  tags = var.tags
}


data "aws_iam_policy" "alb_controller_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
}

# resource "aws_iam_policy" "alb_controller_policy" {
#   name   = "AWSLoadBalancerControllerIAMPolicy"
#   policy = file("${path.module}/iam-policy-alb-controller.json") # 공식 정책 JSON 파일
# }

resource "aws_iam_role_policy_attachment" "alb_controller_attach" {
  role       = aws_iam_role.alb_controller_irsa.name
  policy_arn = data.aws_iam_policy.alb_controller_policy.arn
}
