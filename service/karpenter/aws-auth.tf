data "aws_caller_identity" "current" {}

data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

locals {
  existing_maproles = try(yamldecode(data.kubernetes_config_map_v1.aws_auth.data["mapRoles"]), [])
  
  karpenter_node_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"
  
  karpenter_entry = {
    rolearn  = var.karpenter_node_role_arn
    username = "system:node:{{EC2PrivateDNSName}}"
    groups   = ["system:bootstrappers","system:nodes"]
  }
    existing_without_karpenter = [
    for r in local.existing_maproles :
    r if try(r.rolearn, "") != var.karpenter_node_role_arn
  ]
  # merged_maproles = concat(local.existing_maproles, [local.karpenter_entry])
  merged_maproles = concat(local.existing_without_karpenter, [local.karpenter_entry])
  merged_data = merge(data.kubernetes_config_map_v1.aws_auth.data, { mapRoles = yamlencode(local.merged_maproles) })
}

resource "kubernetes_config_map_v1_data" "aws_auth_patch" {
  count = var.manage_aws_auth_with_terraform ? 1 : 0

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = local.merged_data

  # SSA 필드 소유권을 강제로 가져옴
  field_manager = "Terraform"
  force         = true
}
