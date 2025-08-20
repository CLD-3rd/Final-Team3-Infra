locals {
  oidc_url_hostpath = replace(var.eks_oidc_url, "https://", "")
}

data "aws_iam_policy_document" "kubecost_policy_doc" {
  statement {
    sid     = "KubecostReadOnlyPricingAndDescribe"
    actions = [
      "ec2:Describe*",
      "pricing:GetProducts",
      "s3:GetBucketLocation",
      "s3:ListAllMyBuckets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "kubecost" {
  name        = "${var.cluster_name}-kubecost-policy"
  description = "Policy for Kubecost to query AWS pricing and EC2 describes"
  policy      = data.aws_iam_policy_document.kubecost_policy_doc.json
}

data "aws_iam_policy_document" "kubecost_assume_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.eks_oidc_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url_hostpath}:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.oidc_url_hostpath}:sub"
      values   = ["system:serviceaccount:monitoring:kubecost-cost-analyzer"]
    }
  }
}

resource "aws_iam_role" "kubecost" {
  name               = "${var.cluster_name}-kubecost-irsa"
  assume_role_policy = data.aws_iam_policy_document.kubecost_assume_role.json
}

resource "aws_iam_role_policy_attachment" "kubecost_attach" {
  role       = aws_iam_role.kubecost.name
  policy_arn = aws_iam_policy.kubecost.arn
}

resource "kubernetes_service_account" "kubecost" {
  metadata {
    name      = "kubecost-cost-analyzer"
    namespace = kubernetes_namespace.monitoring.metadata[0].name

    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.kubecost.arn
    }
    labels = {
      "app.kubernetes.io/name" = "kubecost-cost-analyzer"
    }
  }

  automount_service_account_token = true
}