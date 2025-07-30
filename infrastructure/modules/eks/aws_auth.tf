# # aws_auth.tf
# # aws-auth ConfigMap 수정 (kubernetes provider 사용)
# provider "kubernetes" {
#   host                   = aws_eks_cluster.this.endpoint
#   cluster_ca_certificate = base64decode(aws_eks_cluster.this.certificate_authority[0].data)

#   exec {
#     api_version = "client.authentication.k8s.io/v1beta1"
#     command     = "aws"
#     args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name]
#   }
# }

# resource "kubernetes_config_map" "aws_auth" {
#   depends_on = [aws_eks_cluster.this]

#   metadata {
#     name      = "aws-auth"
#     namespace = "kube-system"
#   }

#   data = {
#     mapRoles = yamlencode([
#       {
#         rolearn  = var.node_role_arn
#         username = "system:node:{{EC2PrivateDNSName}}"
#         groups   = ["system:bootstrappers", "system:nodes"]
#       },
#       {
#         rolearn  = var.admin_role_arn
#         username = "admin"
#         groups   = ["system:masters"]
#       }
#     ])

#     mapUsers = yamlencode([
#       {
#         userarn  = var.admin_user_arn
#         username = "admin-user"
#         groups   = ["system:masters"]
#       }
#     ])
#   }
# }
