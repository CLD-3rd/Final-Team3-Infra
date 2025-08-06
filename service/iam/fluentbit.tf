resource "aws_iam_policy" "fluentbit_policy" {
  name = "FluentBitCloudWatchLogsPolicy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "fluentbit_irsa" {
  name = "matchfit-monitoring-fluentbit-irsa-role"
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
            "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub" = "system:serviceaccount/monitoring/fluentbit-sa"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "fluentbit_policy_attach" {
  role       = aws_iam_role.fluentbit_irsa.name
  policy_arn = aws_iam_policy.fluentbit_policy.arn
}

resource "kubernetes_service_account" "fluentbit_sa" {
  metadata {
    name      = "fluentbit-sa"
    namespace = "monitoring"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fluentbit_irsa.arn
    }
  }
}
