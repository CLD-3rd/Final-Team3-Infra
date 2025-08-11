# ALB Controller용 IRSA (IAM Roles for Service Accounts) 역할 생성
resource "aws_iam_role" "alb_controller_irsa" {
  name = "${var.name_prefix}-eks-alb-irsa-role"             # 역할 이름

  # OIDC Provider를 통한 AssumeRole 정책 (IRSA)
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_arn                 # EKS OIDC Provider ARN
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          # 서비스 계정 이름과 네임스페이스에 대한 제약 조건
          "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
        }
      }
    }]
  })

  tags = var.tags
}

# AWS 관리형 ALB Controller 정책 데이터로 불러오기
data "aws_iam_policy" "alb_controller_managed_policy" {
  name = "AWSLoadBalancerControllerIAMPolicy"
}

# 역할에 정책 연결
resource "aws_iam_role_policy_attachment" "alb_controller_attach_managed" {
  role       = aws_iam_role.alb_controller_irsa.name
  policy_arn = data.aws_iam_policy.alb_controller_managed_policy.arn
}

# (선택) 커스텀 정책 파일이 필요하면 아래 주석 해제 후 사용하세요.
# resource "aws_iam_policy" "alb_controller_custom_policy" {
#   name   = "${var.cluster_name}-alb-irsa-custom-policy"
#   policy = file("${path.module}/alb-custom-policy.json")
# }
#
# resource "aws_iam_role_policy_attachment" "alb_controller_attach_custom" {
#   role       = aws_iam_role.alb_controller_irsa.name
#   policy_arn = aws_iam_policy.alb_controller_custom_policy.arn
# }