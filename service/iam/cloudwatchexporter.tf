resource "aws_iam_policy" "cloudwatchexporter_policy" {
  name = var.cloudwatchexporter_policy_name
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:GetMetricStatistics",
          "cloudwatch:GetMetricData", 
          "cloudwatch:ListMetrics",
          "ec2:DescribeInstances",
          "ec2:DescribeRegions",
          "ec2:DescribeAvailabilityZones",
          "rds:DescribeDBInstances",
          "elasticache:DescribeCacheClusters",
          "cloudfront:ListDistributions"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "cloudwatchexporter_irsa" {
  name = "${var.name_prefix}-monitoring-cloudwatchexporter-irsa-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.eks_oidc_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount/${var.monitoring_namespace}/${var.cloudwatchexporter_service_account}"
          }
        }
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cloudwatchexporter_policy_attach" {
  role       = aws_iam_role.cloudwatchexporter_irsa.name
  policy_arn = aws_iam_policy.cloudwatchexporter_policy.arn
}

resource "kubernetes_service_account" "cloudwatchexporter_sa" {
  metadata {
    name      = var.cloudwatchexporter_service_account
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.cloudwatchexporter_irsa.arn
    }
  }
}
