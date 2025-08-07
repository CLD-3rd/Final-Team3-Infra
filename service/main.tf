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
# 서비스 관련 IAM 역할 관련 모듈 호출부
module "iam" {
    source = "./iam"
    name_prefix         = local.name_prefix
    cluster_name        = local.cluster_name
    eks_oidc_arn        = local.eks_oidc_arn
    eks_oidc_url        = local.eks_oidc_url
    tags                = local.tag
}
