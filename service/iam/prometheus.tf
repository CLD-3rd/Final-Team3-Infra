resource "aws_iam_policy" "prometheus_policy" {
  name = "PrometheusMonitoringPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "ec2:DescribeInstances",
          "ec2:DescribeVolumes",
          "tag:GetResources"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "prometheus_irsa" {
  name = "prometheus-irsa-role"
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
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount/monitoring/prometheus-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "prometheus_policy_attach" {
  role       = aws_iam_role.prometheus_irsa.name
  policy_arn = aws_iam_policy.prometheus_policy.arn
}

resource "kubernetes_service_account" "prometheus_sa" {
  metadata {
    name      = "prometheus-sa"
    namespace = "monitoring"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.prometheus_irsa.arn
    }
  }
}
