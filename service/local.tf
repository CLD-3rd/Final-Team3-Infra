locals {
  name_prefix  = data.terraform_remote_state.infra.outputs.name_prefix
  region       = data.terraform_remote_state.infra.outputs.aws_region
  tag          = data.terraform_remote_state.infra.outputs.default_tags

  cluster_name = data.terraform_remote_state.infra.outputs.eks_cluster_name
  node_group_name = data.terraform_remote_state.infra.outputs.node_group_name

  eks_oidc_arn = data.terraform_remote_state.infra.outputs.oidc_provider_arn
  eks_oidc_url = data.terraform_remote_state.infra.outputs.cluster_oidc_issuer_url
}