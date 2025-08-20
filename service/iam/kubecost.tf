data "aws_iam_policy_document" "kubecost_policy_doc" {
  statement {
    sid = "EC2Describe"
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeRegions",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeReservedInstances",
      "ec2:DescribeReservedInstancesOfferings",
      "ec2:DescribeSpotPriceHistory"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AutoScalingDescribe"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations"
    ]
    resources = ["*"]
  }

  statement {
    sid = "PricingAndCostExplorerRead"
    actions = [
      "pricing:GetProducts",
      "ce:GetCostAndUsage"
    ]
    resources = ["*"]
  }

  statement {
    sid = "STSGetCallerIdentity"
    actions = ["sts:GetCallerIdentity"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "kubecost" {
  name        = "${var.name_prefix}-monitoring-kubecost-policy"
  description = "Read-only permissions for Kubecost cost-model on EKS (IRSA)"
  policy      = data.aws_iam_policy_document.kubecost_policy_doc.json
  tags        = var.tags
}

data "aws_iam_policy_document" "kubecost_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${kubernetes_namespace.monitoring.metadata[0].name}:${var.kubecost_service_account}"]
    }
    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "kubecost_irsa" {
  name               = "${var.name_prefix}-monitoring-kubecost-irsa-role"
  assume_role_policy = data.aws_iam_policy_document.kubecost_assume_role.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "kubecost_attach" {
  role       = aws_iam_role.kubecost_irsa.name
  policy_arn = aws_iam_policy.kubecost.arn
}

resource "kubernetes_service_account" "kubecost" {
  metadata {
    name      = var.kubecost_service_account
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kubecost_irsa.arn
    }
  }
  automount_service_account_token = true

  depends_on = [kubernetes_namespace.monitoring]
}
