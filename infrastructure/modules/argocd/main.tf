resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = "6.7.4"
  namespace        = "argocd"
  create_namespace = true

# values 값은 Helm 차트의 설정값을 YAML로 인코딩해서 전달
values = [
  yamlencode({
    server = {
      ingress = {
        enabled = true  # Ingress 리소스를 활성화하여 외부 접근 허용
        ingressClassName = "alb"  # 사용하는 Ingress Controller는 AWS ALB
        annotations = {
          # 인터넷에 노출되는 ALB로 구성
          "alb.ingress.kubernetes.io/scheme"                      = "internet-facing"

          # ALB가 대상으로 삼을 타입: ip → Pod의 IP로 트래픽 전달
          "alb.ingress.kubernetes.io/target-type"                 = "ip"

          # ALB 그룹을 "argocd"로 지정 (다른 ALB Ingress와 격리)
          "alb.ingress.kubernetes.io/group.name"                  = "argocd"

          # ALB가 수신할 포트를 JSON 배열 형식으로 설정 (HTTP 80)
          "alb.ingress.kubernetes.io/listen-ports"                = "[{\"HTTP\": 80}]"

          # ALB가 헬스체크를 수행할 경로 설정 (ArgoCD 서버 기본 health endpoint)
          "alb.ingress.kubernetes.io/healthcheck-path"            = "/healthz"

          # ALB 헬스체크 시 성공으로 간주할 HTTP 코드
          "alb.ingress.kubernetes.io/success-codes"               = "200"
        }

        # ALB 도메인 라우팅을 위한 호스트 이름 지정
        hosts = ["argocd.match-fit.store"]
      }
    }
  })
]
}