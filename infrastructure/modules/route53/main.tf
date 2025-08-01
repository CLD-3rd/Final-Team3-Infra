# Route53 퍼블릭 호스팅 존 data 불러오기
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}
# ArgoCD 접근용 서브도메인 A 레코드 (ALIAS) 생성
resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "argocd.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.argocd_alb_dns
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Route53 퍼블릭 호스팅 존 생성
# resource "aws_route53_zone" "primary" {
#   name = var.domain_name
#   lifecycle {
#   prevent_destroy = true
#   }
# }

# ALB 정보 조회 (dns name, zone id)
# data "aws_lb" "argocd" {
#   name = var.argocd_alb_dns
# }