# resource "kubernetes_namespace" "karpenter" {
#   metadata {
#     name = "karpenter"
#   }
# }

resource "kubernetes_service_account" "karpenter" {
  metadata {
    name      = "karpenter"
    namespace = kubernetes_namespace.karpenter.metadata[0].name
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_irsa.arn
    }
  }
}
