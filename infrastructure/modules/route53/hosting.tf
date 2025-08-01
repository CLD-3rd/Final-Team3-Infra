# Route53 퍼블릭 호스팅 존 생성
# resource "aws_route53_zone" "primary" {
#   name = var.domain_name
#   lifecycle {
#   prevent_destroy = true
#   }
# }

# Route53 퍼블릭 호스팅 존 data 불러오기
data "aws_route53_zone" "primary" {
  name         = var.domain_name
  private_zone = false
}