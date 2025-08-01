# # kubernetes provider 설정
# provider "kubernetes" {
#   host                   = aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)
#   token                  = data.aws_eks_cluster_auth.this.token
# }

# # EKS 인증용 데이터 소스
# data "aws_eks_cluster_auth" "this" {
#   name = aws_eks_cluster.this.name
# }

# # aws-auth ConfigMap 정의
# resource "kubernetes_config_map" "aws_auth" {
#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = aws_iam_role.eks_node_role.arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups   = [
#           "system:bootstrappers",
#           "system:nodes"
#         ]
#       }
#     ])
#   }

#   depends_on = [aws_eks_cluster.this]
# }