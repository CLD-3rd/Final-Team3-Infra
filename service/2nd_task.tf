# # CloudFront (OAC + HTTPS)
# module "cloudfront" {
#   source                         = "./cloudfront"
#   name_prefix                    = local.name_prefix
#   region                         =  local.region
#   cluster_name                   = local.cluster_name
#   domain_name                    = var.domain_name
#   price_class                    = var.price_class
#   custom_error_responses         = var.custom_error_responses
#   cloudfront_certificate_arn     = var.cloudfront_certificate_arn
#   # S3 연동
#   cloudfront_bucket_name         = local.cloudfront_bucket_name
#   s3_origin_domain               = local.s3_origin_domain  # 기존 S3 모듈의 도메인
#   s3_bucket_id                   = local.s3_bucket_id                     # 기존 S3 모듈의 ID
#   s3_bucket_arn                  = local.s3_bucket_arn                    # 기존 S3 모듈의 ARN
#   tags                           = local.tag
#   # Logging result
#   grafana_irsa_role_name         = module.iam.grafana_irsa_role_name
#   # Route53 Record
#   hosting_zone_id                = module.route53_argocd.hosting_zone_id
# }
# ### 개선사항 : 캐시무효화 자동화에 대한 부분은 CI에서 처리, 배포 후 캐시 갱신은 CD 파이프라인에서 처리

# #################################
# # CloudFront + S3 설정
# variable "cloudfront_certificate_arn" {
#   description = "CloudFront용 인증서 ARN (us-east-1)"
#   type        = string
# }
# variable "price_class" {
#   description = "CloudFront 가격 클래스"
#   type        = string
#   default     = "PriceClass_200"
# }
# variable "custom_error_responses" {
#   description = "커스텀 에러 페이지 설정 (SPA 라우팅용)"
#   type = list(object({
#     error_code         = number
#     response_code      = number
#     response_page_path = string
#   }))
#   default = []
# }