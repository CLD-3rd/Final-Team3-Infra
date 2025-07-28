resource "aws_route53_zone" "main" {
  name = "match-fit.store"
}

resource "aws_route53_record" "argocd" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "argocd.match-fit.store"
  type    = "A"

  alias {
    name                   = module.alb_controller.alb_dns_name  # ALB DNS
    zone_id                = module.alb_controller.alb_zone_id   # ALB Zone ID
    evaluate_target_health = true
  }
}
