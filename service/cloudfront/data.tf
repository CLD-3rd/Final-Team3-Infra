data "aws_lb" "eks_alb" {
  filter {
    name   = "tag:kubernetes.io/service-name"
    values = ["kube-system/aws-load-balancer-controller"]
  }
  filter {
    name   = "type"
    values = ["application"]
  }
}