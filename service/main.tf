# # EKS Autoscaling 관련 모듈 호출부
# # CA 모듈 호출
# module "cluster_autoscaler" {
#   source               = "./modules/cluster-autoscaler"
#   cluster_name         = var.cluster_name                    # CA가 관리할 클러스터 식별
#   node_group_name      = module.eks.node_group_name          # 특정 노드 그룹 식별
#   cluster_oidc_url     = module.eks.cluster_oidc_issuer_url  # IRSA를 위한 해당 URL로 IAM 역할의 신뢰 정책 작성
#   oidc_provider_arn    = module.eks.oidc_provider_arn        # 해당 ARN을 이용해 IAM 역할을 생성할 때 필요
#   aws_region           = var.aws_region
#   tags                 = var.default_tags
# }
# ############################

module "iam" {
    source = "./iam"
    cluster_name = local.cluster_name
    oidc_provider_arn = local.eks_oidc_arn
    oidc_provider_url = local.eks_oidc_url
}
