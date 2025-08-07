resource "aws_iam_policy" "fluentbit_policy" {
  name   = var.fluentbit_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "fluentbit_irsa" {
  name = "${var.name_prefix}-monitoring-fluentbit-irsa-role"
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
            "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount/${var.monitoring_namespace}/${var.fluentbit_service_account}"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "fluentbit_policy_attach" {
  role       = aws_iam_role.fluentbit_irsa.name
  policy_arn = aws_iam_policy.fluentbit_policy.arn
}

resource "kubernetes_service_account" "fluentbit_sa" {
  metadata {
    name      = var.fluentbit_service_account
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fluentbit_irsa.arn
    }
  }
}

#CloudWatch 로그 그룹 관련 리소스
# FluentBit CloudWatch LogGroup
resource "aws_cloudwatch_log_group" "fluentbit" {
  name              = "/aws/eks/${var.cluster_name}/application"
  retention_in_days = 30
  tags              = var.tags
}