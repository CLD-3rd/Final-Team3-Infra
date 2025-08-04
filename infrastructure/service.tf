# # 서비스 모듈
# # IRSA용 IAM 역할 및 정책 구성
# module "irsa-alb" {
#   source = "./modules/alb-irsa"
#   cluster_name = var.cluster_name
#   oidc_provider_arn = module.eks.oidc_provider_arn
#   oidc_provider_url = module.eks.cluster_oidc_issuer_url
#   tags = var.default_tags
# }
# # ALB Controller Helm 설치
# module "alb_controller" {
#   source = "./modules/alb-controller"
#   cluster_name                 = module.eks.cluster_name
#   vpc_id                       = module.network.vpc_id
#   alb_controller_irsa_role_arn = module.irsa-alb.alb_controller_irsa_role_arn
#   depends_on = [module.irsa-alb]
# }
# # ArgoCD Helm 설치
# module "argocd" {
#   source = "./modules/argocd"
#   depends_on = [module.alb_controller]
# }
# ###########################
# # Route53 DNS 설정 모듈 호출
# module "route53" {
#   source              = "./modules/route53"
#   domain_name         = var.domain_name
#   # argocd_alb_dns    = module.argocd.argocd_alb_dns
#   cloudfront_dns      = module.cloudfront.cloudfront_dns
# }