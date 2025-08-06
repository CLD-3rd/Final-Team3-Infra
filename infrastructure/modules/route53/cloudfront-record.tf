# resource "aws_route53_record" "cloudfront" {
#   zone_id = data.aws_route53_zone.primary.zone_id
#   name    = "cloudfront.${var.domain_name}"
#   type    = "A"

#   alias {
#     name                   = var.cloudfront_dns
#     zone_id                = "Z2FDTNDATAQYW2"
#     evaluate_target_health = false
#   }
#   lifecycle {
#   # prevent_destroy = true # 삭제 막기
#     ignore_changes = all # 모든 변경 무시
#   }
# }
# variable "cloudfront_dns" {
#   description = "CloudFront DNS 이름"
#   type        = string
# }