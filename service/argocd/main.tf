# ArgoCD Helm 차트를 설치하는 리소스
resource "helm_release" "argocd" {
  name             = "argocd"                               # Helm release 이름
  repository       = "https://argoproj.github.io/argo-helm" # Helm 차트 저장소 URL
  chart            = "argo-cd"                              # 설치할 Helm 차트명
  version          = "6.7.4"                                # 설치할 Helm 차트 버전
  namespace        = "argocd"                               # 설치할 네임스페이스
  create_namespace = true                                   # 네임스페이스가 없으면 생성

  # Helm 차트에 전달할 값들을 YAML로 인코딩하여 전달
  values = [
    yamlencode({
      server = {
        ingress = {
          enabled          = true                          # Ingress 리소스 활성화
          ingressClassName = "alb"                         # AWS ALB Ingress Controller 사용 지정
          annotations = {
            # 인터넷에 노출되는 ALB 설정
            "alb.ingress.kubernetes.io/scheme"           = "internet-facing"

            # ALB 타겟 타입: Pod IP를 대상으로 지정
            "alb.ingress.kubernetes.io/target-type"      = "ip"

            # ALB 그룹 이름 지정 (여러 ALB 격리 목적)
            "alb.ingress.kubernetes.io/group.name"       = "argocd"

            # ALB가 수신할 포트 설정
            "alb.ingress.kubernetes.io/listen-ports"     = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"

            # ACM 인증
            "alb.ingress.kubernetes.io/certificate-arn" = "arn:aws:acm:ap-northeast-2:061039804626:certificate/6beca310-1a10-4262-848e-119061924427"

            # HTTP를 HTTPS로 리다이렉트
            "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode({
              Type = "redirect"
              RedirectConfig = {
                Protocol   = "HTTPS"
                Port       = "443"
                StatusCode = "HTTP_301"
              }
            })

            # ALB 헬스체크 경로 설정 (ArgoCD 기본 헬스 체크)
            "alb.ingress.kubernetes.io/healthcheck-path" = "/healthz"

            # 헬스체크 시 정상으로 판단할 HTTP 응답 코드
            "alb.ingress.kubernetes.io/success-codes"    = "200"
          }

          # ALB가 라우팅할 도메인 호스트 이름
          hostname = "argocd.${var.domain_name}" 
          hosts    = ["argocd.${var.domain_name}"]
        #   https = true

          # HTTP 요청을 HTTPS로 리다이렉트하는 추가 경로 설정
          extraPaths = [
            {
              path = "/*"
              backend = {
                serviceName = "ssl-redirect"
                servicePort = "use-annotation"
              }
            }
          ]
        }

        service = {
          type = "ClusterIP"
          ports = {
            http = 80
          }
        }
      }
    })
  ]
}

# ArgoCD Ingress 리소스를 참조하는 데이터 소스
data "kubernetes_ingress_v1" "argocd" {
  metadata {
    name      = "argocd-server"  # ArgoCD 서버 Ingress 이름
    namespace = "argocd"         # 네임스페이스
  }

  depends_on = [helm_release.argocd] # Helm 설치 완료 후 조회
}
