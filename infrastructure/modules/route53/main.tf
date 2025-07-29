# Route53 퍼블릭 호스팅 존 생성
resource "aws_route53_zone" "primary" {
  name = var.domain_name               # 관리할 도메인 이름
}

# ArgoCD 접근용 서브도메인 CNAME 레코드 생성
resource "aws_route53_record" "argocd" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "argocd.${var.domain_name}"  # 서브도메인 이름
  type    = "CNAME"
  ttl     = 300
  records = [var.argocd_alb_dns]         # ALB DNS 이름 참조
}
