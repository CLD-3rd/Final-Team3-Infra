resource "aws_iam_policy" "grafana_policy" {
  name = "GrafanaCloudWatchReadOnly"
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
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "grafana_irsa" {
  name = "grafana-irsa-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount/monitoring/grafana-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "grafana_policy_attach" {
  role       = aws_iam_role.grafana_irsa.name
  policy_arn = aws_iam_policy.grafana_policy.arn
}

resource "kubernetes_service_account" "grafana_sa" {
  metadata {
    name      = "grafana-sa"
    namespace = "monitoring"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.grafana_irsa.arn
    }
  }
}
