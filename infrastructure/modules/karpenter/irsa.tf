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

  # 2) 정확한 Karpenter Node Role ARN
  karpenter_node_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"

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

  merged_maproles = concat(local.existing_without_karpenter, [local.karpenter_entry])

  merged_data = merge(
    data.kubernetes_config_map_v1.aws_auth.data,
    { mapRoles = yamlencode(local.merged_maproles) }
  )
}

resource "kubernetes_config_map_v1" "aws_auth_patch" {

  depends_on = [aws_cloudformation_stack.karpenter]

  metadata {
    name      = data.kubernetes_config_map_v1.aws_auth.metadata[0].name
    namespace = data.kubernetes_config_map_v1.aws_auth.metadata[0].namespace
  }
  data = local.merged_data
}

locals {
  karpenter_oidc_host = replace(var.oidc_issuer_url, "https://", "")
  # CFN 템플릿이 만든 Managed Policy ARN for controller (we expect it from CFN)
  karpenter_controller_policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterControllerPolicy-${var.cluster_name}"
}

resource "aws_iam_role" "karpenter_controller" {
  name = "KarpenterControllerRole-${var.cluster_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            # key must be "<oidc_host>:sub"
            "${local.karpenter_oidc_host}:sub" = "system:serviceaccount:kube-system:karpenter",
            # audience check
            "${local.karpenter_oidc_host}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
    "created-by" = "terraform"
  }
}

# Attach the controller policy created by the CFN template.
resource "aws_iam_role_policy_attachment" "attach_controller_policy" {
  # ensure the cloudformation policy exists first
  depends_on = [ aws_cloudformation_stack.karpenter ]

  role       = aws_iam_role.karpenter_controller.name
  policy_arn = local.karpenter_controller_policy_arn
}

# (옵션) 추가적 AWS managed policies가 필요하면 아래처럼 추가 가능
# resource "aws_iam_role_policy_attachment" "attach_ecr_readonly" {
#   role       = aws_iam_role.karpenter_controller.name
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
# }