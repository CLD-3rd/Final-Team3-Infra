resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.7.1"
  namespace  = "kube-system"
  create_namespace = false                        # kube-system은 이미 존재하므로 생성하지 않음

  # Helm chart에 전달할 설정값 정의
  values = [
    yamlencode({
      clusterName = var.cluster_name
      serviceAccount = {
        create = true                             # 서비스 계정 생성 여부
        name   = "aws-load-balancer-controller"   # IRSA 연동용 서비스 계정 이름
        annotations = {
          "eks.amazonaws.com/role-arn" = var.alb_controller_irsa_role_arn
        }
      }
    })
  ]

}