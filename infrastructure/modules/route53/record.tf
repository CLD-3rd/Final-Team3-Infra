# ALB 정보 조회 (dns name, zone id)
# data "aws_lb" "argocd" {
#   name = var.argocd_alb_dns
# }

# data "aws_lb" "argocd_alb" {
#   name = "k8s-argocd-argocdse-c7ff3d7e73-4cc30985b0c17628.elb.ap-northeast-2.amazonaws.com" # 실제 ALB 이름으로 대체
# }

# ArgoCD 접근용 서브도메인 A 레코드 (ALIAS) 생성
resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.argocd_alb_dns
    zone_id                = "ZWKZPGTI48KDX"
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "cloudfront.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_dns
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}