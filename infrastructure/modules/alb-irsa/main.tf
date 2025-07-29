# ALB Controller용 IRSA (IAM Roles for Service Accounts) 역할 생성
resource "aws_iam_role" "alb_controller_irsa" {
  name = "${var.cluster_name}-alb-irsa-role"             # 역할 이름

  # OIDC Provider를 통한 AssumeRole 정책 (IRSA)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.oidc_provider_arn                 # EKS OIDC Provider ARN
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          # 서비스 계정 이름과 네임스페이스에 대한 제약 조건
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
