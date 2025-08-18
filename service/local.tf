locals {
  name_prefix  = data.terraform_remote_state.infra.outputs.name_prefix
  region       = data.terraform_remote_state.infra.outputs.aws_region
  tag          = data.terraform_remote_state.infra.outputs.default_tags

  cluster_name = data.terraform_remote_state.infra.outputs.eks_cluster_name
  node_group_name = data.terraform_remote_state.infra.outputs.node_group_name

  vpc_id = data.terraform_remote_state.infra.outputs.vpc_id

  eks_oidc_arn = data.terraform_remote_state.infra.outputs.oidc_provider_arn
  eks_oidc_url = data.terraform_remote_state.infra.outputs.cluster_oidc_issuer_url
  
  cloudfront_bucket_name = data.terraform_remote_state.infra.outputs.app_bucket_name
  image_bucket_name      = data.terraform_remote_state.infra.outputs.image_bucket_name
  s3_bucket_id           = data.terraform_remote_state.infra.outputs.s3_bucket_id
  s3_bucket_arn          = data.terraform_remote_state.infra.outputs.s3_bucket_arn
  s3_origin_domain       = data.terraform_remote_state.infra.outputs.bucket_regional_domain_name

  karpenter_node_role_arn       = data.terraform_remote_state.infra.outputs.karpenter_node_role_arn
  karpenter_controller_role_arn = data.terraform_remote_state.infra.outputs.karpenter_controller_role_arn
}