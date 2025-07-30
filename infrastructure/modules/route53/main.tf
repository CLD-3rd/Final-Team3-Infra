# Route53 퍼블릭 호스팅 존 생성
resource "aws_route53_zone" "primary" {
  name = var.domain_name
}

# ALB 정보 조회 (dns name, zone id)
data "aws_lb" "argocd" {
  name = var.argocd_alb_dns
}

# ArgoCD 접근용 서브도메인 A 레코드 (ALIAS) 생성
resource "aws_route53_record" "argocd" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "A"

  alias {
    name                   = data.aws_lb.argocd.dns_name
    zone_id                = data.aws_lb.argocd.zone_id
    evaluate_target_health = true
  }
}
