data "terraform_remote_state" "infra" {
  backend = "s3"   # 이미 사용중인 backend 설정에 맞춰 수정 (여기선 예시)
  config = {
    bucket = "..." # 기존 설정을 참고
    key    = "..." 
    region = "ap-northeast-2"
  }
}

data "aws_caller_identity" "current" {}

data "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
}

locals {
  existing_maproles = try(yamldecode(data.kubernetes_config_map_v1.aws_auth.data["mapRoles"]), [])
  karpenter_entry = {
    rolearn  = data.terraform_remote_state.infra.outputs.karpenter_node_role_arn
    username = "system:node:{{EC2PrivateDNSName}}"
    groups   = ["system:bootstrappers","system:nodes"]
  }
  merged_maproles = concat(local.existing_maproles, [local.karpenter_entry])
  merged_data = merge(data.kubernetes_config_map_v1.aws_auth.data, { mapRoles = yamlencode(local.merged_maproles) })
}

resource "kubernetes_config_map_v1" "aws_auth_patch" {
  metadata {
    name      = data.kubernetes_config_map_v1.aws_auth.metadata[0].name
    namespace = data.kubernetes_config_map_v1.aws_auth.metadata[0].namespace
  }
  data = local.merged_data
}
