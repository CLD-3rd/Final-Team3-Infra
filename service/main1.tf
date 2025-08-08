# apply 전에 명령어 꼭 수행하기!
# aws eks update-kubeconfig --name matchfit-eks --region ap-northeast-2 --role-arn arn:aws:iam::061039804626:role/matchfit-eks-admin-role
############################
# EKS Autoscaling 관련 모듈 호출부
# CA 모듈 호출
module "cluster_autoscaler" {
  source               = "./ca"
  cluster_name         = local.cluster_name                    # CA가 관리할 클러스터 식별
  node_group_name      = local.node_group_name          # 특정 노드 그룹 식별
  eks_oidc_arn         = local.eks_oidc_arn      # 해당 ARN을 이용해 IAM 역할을 생성할 때 필요
  eks_oidc_url         = local.eks_oidc_url      # IRSA를 위한 해당 URL로 IAM 역할의 신뢰 정책 작성
  region               = local.region
  tags                 = local.tag
}
############################
# IAM역할(서비스) 관련 모듈 호출부
module "iam" {
    source = "./iam"
    name_prefix         = local.name_prefix
    cluster_name        = local.cluster_name
    eks_oidc_arn        = local.eks_oidc_arn
    eks_oidc_url        = local.eks_oidc_url
    tags                = local.tag
}
############################
# EKS 내에 ALB 관련 Helm Chart 설치 모듈 호출부
# ALB Controller Helm 설치
module "alb_controller" {
  source = "./alb-controller"
  cluster_name                 = local.cluster_name
  vpc_id                       = local.vpc_id
  alb_irsa_role_arn            = module.iam.alb_irsa_role_arn
  depends_on                   = [module.iam]
}
# ArgoCD Helm 설치
module "argocd" {
  source = "./argocd"
  domain_name     = var.domain_name
  depends_on = [module.alb_controller]
}
#################################
# Route53 DNS 설정 모듈 호출
module "route53_argocd" {
  source          = "./route53"
  domain_name     = var.domain_name
  argocd_alb_dns  = module.argocd.argocd_alb_dns
  cloudfront_dns  = module.cloudfront.cloudfront_dns
  depends_on      = [
    module.argocd
    , module.cloudfront
  ]
}