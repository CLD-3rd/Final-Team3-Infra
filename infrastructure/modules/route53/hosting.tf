# Route53 퍼블릭 호스팅 존 생성용 선언
# resource "aws_route53_zone" "primary" {
#   name = var.domain_name
#   # lifecycle {
#   # prevent_destroy = true
#   # }
# }

# Route53 퍼블릭 호스팅 존 data 불러오는 용 선언
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}