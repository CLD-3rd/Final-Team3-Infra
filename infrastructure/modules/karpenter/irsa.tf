data "aws_caller_identity" "current" {}

data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

locals {
  # 1) 기존 mapRoles 파싱
  existing_maproles = try(yamldecode(data.kubernetes_config_map_v1.aws_auth.data["mapRoles"]), [])

  # 2) 정확한 Karpenter Node Role ARN (infra remote state 사용이 제일 안전)
  karpenter_node_role_arn = data.terraform_remote_state.infra.outputs.karpenter_node_role_arn

  karpenter_entry = {
    rolearn  = local.karpenter_node_role_arn
    username = "system:node:{{EC2PrivateDNSName}}"
    groups   = ["system:bootstrappers","system:nodes"]
  }

  # 3) 같은 rolearn을 가진 기존 엔트리를 제거(중복 방지)
  existing_without_karpenter = [
    for r in local.existing_maproles :
    r if try(r.rolearn, "") != local.karpenter_node_role_arn
  ]

  merged_maproles = concat(existing_without_karpenter, [local.karpenter_entry])

  merged_data = merge(
    data.kubernetes_config_map_v1.aws_auth.data,
    { mapRoles = yamlencode(local.merged_maproles) }
  )
}

resource "kubernetes_config_map_v1" "aws_auth_patch" {
  metadata {
    name      = data.kubernetes_config_map_v1.aws_auth.metadata[0].name
    namespace = data.kubernetes_config_map_v1.aws_auth.metadata[0].namespace
  }
  data = local.merged_data
}
