resource "kubernetes_service_account" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_irsa.arn
    }
  }
}
