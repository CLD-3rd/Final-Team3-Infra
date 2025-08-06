# 서비스 모듈

# apply 전에 명령어 꼭 수행하기!
# aws eks update-kubeconfig --name matchfit-eks --region ap-northeast-2 --role-arn arn:aws:iam::061039804626:role/matchfit-eks-admin-role

############################
# EKS Autoscaling 관련 모듈 호출부
# CA 모듈 호출
module "cluster_autoscaler" {
  source               = "./modules/cluster-autoscaler"
  cluster_name         = var.cluster_name                    # CA가 관리할 클러스터 식별
  node_group_name      = module.eks.node_group_name          # 특정 노드 그룹 식별
  cluster_oidc_url     = module.eks.cluster_oidc_issuer_url  # IRSA를 위한 해당 URL로 IAM 역할의 신뢰 정책 작성
  oidc_provider_arn    = module.eks.oidc_provider_arn        # 해당 ARN을 이용해 IAM 역할을 생성할 때 필요
  aws_region           = var.aws_region
  tags                 = var.default_tags
}
############################
# EKS 내에 ALB 관련 Helm Chart 설치 모듈 호출부
# IRSA용 IAM 역할 및 정책 구성
module "irsa-alb" {
  source = "./modules/alb-irsa"
  cluster_name = var.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.cluster_oidc_issuer_url
  tags = var.default_tags
}
# ALB Controller Helm 설치
module "alb_controller" {
  source = "./modules/alb-controller"
  cluster_name                 = module.eks.cluster_name
  vpc_id                       = module.network.vpc_id
  alb_controller_irsa_role_arn = module.irsa-alb.alb_controller_irsa_role_arn
  depends_on = [module.irsa-alb]
}
# ArgoCD Helm 설치
module "argocd" {
  source = "./modules/argocd"
  domain_name     = var.domain_name
  depends_on = [module.alb_controller]
}
###########################
# Route53 DNS 설정 모듈 호출
module "route53" {
  source              = "./modules/route53"
  domain_name         = var.domain_name
  argocd_alb_dns    = module.argocd.argocd_alb_dns
  cloudfront_dns      = module.cloudfront.cloudfront_dns
  depends_on        = [module.argocd, module.cloudfront]
}