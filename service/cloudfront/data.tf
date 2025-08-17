# data "aws_lb" "eks_alb" {
#   filter {
#     name   = "tag:elbv2.k8s.aws/cluster"
#     values = ["${var.cluster_name}"]
#   }
#   filter {
#   name   = "tag:ingress.k8s.aws/stack"
#   values = ["backend"]
#   }
#   filter {
#     name   = "tag:ingress.k8s.aws/resource"
#     values = ["LoadBalancer"]
#   }
# }
data "aws_caller_identity" "current" {}
data "aws_lb" "eks_alb" {
  tags = {
    "elbv2.k8s.aws/cluster"    = var.cluster_name
    "ingress.k8s.aws/stack"    = "backend"
    "ingress.k8s.aws/resource" = "LoadBalancer"
  }
}
