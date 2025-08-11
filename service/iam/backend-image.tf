resource "aws_iam_role" "s3_access_role" {
  name = "${var.name_prefix}-backend-s3-access-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = var.eks_oidc_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(var.eks_oidc_url, "https://", "")}:sub" = "system:serviceaccount:${var.backend_namespace}:${var.backend_service_account}"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "matchfit-backend-s3-access-policy"
  role = aws_iam_role.s3_access_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::${var.image_bucket_name}/*"
        # Resource = "arn:aws:s3:::matchfit-front-image/*"
      }
    ]
  })
}

resource "kubernetes_service_account" "backend_sa" {
  metadata {
    name      = var.backend_service_account
    namespace = "argocd"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.s3_access_role.arn
    }
  }
}

