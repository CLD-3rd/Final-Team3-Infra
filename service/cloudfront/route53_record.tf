resource "aws_route53_record" "cloudfront" {
  zone_id = var.hosting_zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
  lifecycle {
  # prevent_destroy = true # 삭제 막기
    ignore_changes = all # 모든 변경 무시
  }
}
# 모듈 분리 시에 필요한 변수
# variable "cloudfront_dns" {
#   description = "CloudFront DNS 이름"
#   type        = string
# }