# AWS Load Balancer Controller Helm 차트를 설치하는 리소스
resource "helm_release" "alb_controller" {
  name       = "aws-load-balancer-controller"             # Helm release 이름
  repository = "https://aws.github.io/eks-charts"         # Helm 차트 저장소 URL
  chart      = "aws-load-balancer-controller"             # 설치할 Helm 차트명
  version    = "1.7.1"                                    # 설치할 Helm 차트 버전
  namespace  = "kube-system"                              # 설치할 네임스페이스
  create_namespace = false                                # kube-system은 이미 존재하므로 네임스페이스 생성 안 함

  # Helm 차트에 넘길 값들을 YAML 형식으로 인코딩하여 전달
  values = [
    yamlencode({
      clusterName = var.cluster_name                      # 대상 EKS 클러스터 이름
      serviceAccount = {
        create = true                                     # 서비스 계정 생성 여부
        name   = "aws-load-balancer-controller"          # IRSA용 서비스 계정 이름
        annotations = {
          "eks.amazonaws.com/role-arn" = var.alb_controller_irsa_role_arn  # IAM Role ARN 연결
        }
      }
    })
  ]

}
