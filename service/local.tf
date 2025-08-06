locals {
  name_prefix  = data.terraform_remote_state.infra.outputs.name_prefix
  tag          = data.terraform_remote_state.infra.outputs.default_tags
  cluster_name = data.terraform_remote_state.infra.outputs.eks_cluster_name

  eks_oidc_arn = data.terraform_remote_state.infra.outputs.eks_oidc_provider_arn
  eks_oidc_url = data.terraform_remote_state.infra.outputs.eks_oidc_provider_url
}