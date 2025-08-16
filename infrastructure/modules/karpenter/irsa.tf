data "aws_caller_identity" "current" {}

# OIDC provider arn/url는 parent (module.eks)에서 전달받음
resource "aws_iam_role" "karpenter_irsa" {
  name = "${var.cluster_name}-karpenter"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = { Federated = var.oidc_provider_arn },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer_url, "https://", "")}:sub" = "system:serviceaccount:karpenter:karpenter"
        }
      }
    }]
  })
}

# CFN이 만든 정책 이름은 일반적으로 "KarpenterControllerPolicy-<cluster>" 이므로 ARN을 구성
resource "aws_iam_role_policy_attachment" "karpenter_attach" {
  role       = aws_iam_role.karpenter_irsa.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterControllerPolicy-${var.cluster_name}"
}
