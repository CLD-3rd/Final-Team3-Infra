resource "aws_iam_policy" "grafana_policy" {
  name   = var.grafana_policy_name
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cloudwatch:ListDashboards",
          "cloudwatch:GetDashboard",
          "cloudwatch:GetMetricData",
          "cloudwatch:ListMetrics",
          "logs:GetLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:StartQuery",
          "logs:StopQuery",
          "logs:GetQueryResults"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "grafana_irsa" {
  name = "${var.name_prefix}-monitoring-grafana-irsa-role"
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
            "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount:${var.monitoring_namespace}:${var.grafana_service_account}"
          }
        }
      }
    ]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "grafana_policy_attach" {
  role       = aws_iam_role.grafana_irsa.name
  policy_arn = aws_iam_policy.grafana_policy.arn
}

resource "kubernetes_service_account" "grafana_sa" {
  metadata {
    name      = var.grafana_service_account
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.grafana_irsa.arn
    }
  }
}
