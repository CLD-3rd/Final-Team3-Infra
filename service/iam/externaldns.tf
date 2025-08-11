resource "aws_iam_policy" "externaldns_policy" {
  name        = var.externaldns_policy_name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = "arn:aws:route53:::hostedzone/*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "route53:ListHostedZones",
          "route53:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "externaldns_irsa" {
  name = "${var.name_prefix}-argocd-externaldns-irsa-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.eks_oidc_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount:${var.externaldns_namespace}:${var.externaldns_service_account}"
            "${replace(var.eks_oidc_url, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "externaldns_policy_attach" {
  role     = aws_iam_role.externaldns_irsa.name
  policy_arn = aws_iam_policy.externaldns_policy.arn
}
