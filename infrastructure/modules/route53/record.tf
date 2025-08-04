# ALB 정보 조회 (dns name, zone id)
# data "aws_lb" "argocd" {
#   name = var.argocd_alb_dns
# }

# ArgoCD 접근용 서브도메인 A 레코드 (ALIAS) 생성
# resource "aws_route53_record" "argocd" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "argocd.${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = var.argocd_alb_dns
#     zone_id                = "Z3W03O7B5YMIYP"
#     evaluate_target_health = true
#   }
# }

resource "aws_route53_record" "cloudfront" {
  zone_id = data.aws_route53_zone.primary.zone_id
  # 생성 시에는 aws_route53_zone.primary.zone_id 사용
  name    = "cloudfront.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_dns
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}