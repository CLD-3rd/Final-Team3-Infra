resource "aws_iam_policy" "prometheus_policy" {
  name   = var.prometheus_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:GetMetricData",
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:ListMetrics"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "prometheus_irsa" {
  name = "${var.name_prefix}-monitoring-prometheus-irsa-role"
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
            "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount:${var.monitoring_namespace}:${var.prometheus_service_account}"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "prometheus_policy_attach" {
  role       = aws_iam_role.prometheus_irsa.name
  policy_arn = aws_iam_policy.prometheus_policy.arn
}

resource "kubernetes_service_account" "prometheus_sa" {
  metadata {
    name      = var.prometheus_service_account
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.prometheus_irsa.arn
    }
  }
}
