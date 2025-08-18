data "http" "karpenter_cfn" {
  url = "https://raw.githubusercontent.com/aws/karpenter/main/website/content/en/preview/getting-started/getting-started-with-karpenter/cloudformation.yaml"
}

resource "aws_cloudformation_stack" "karpenter" {
  name          = "Karpenter-${var.cluster_name}"
  template_body = data.http.karpenter_cfn.response_body
  capabilities  = ["CAPABILITY_NAMED_IAM"]

  # CFN 템플릿 파라미터 (템플릿에 따라 이름이 다를 수 있으니 템플릿 확인 후 수정)
  parameters = {
    ClusterName = var.cluster_name
  }
}
# 태그 셀렉터를 위해 서브넷/SG에 태그 추가
resource "aws_ec2_tag" "subnet_discovery" {
  for_each    = toset(var.subnet_ids)
  resource_id = each.value
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}

resource "aws_ec2_tag" "node_sg_discovery" {
  resource_id = var.node_sg_id
  key         = "karpenter.sh/discovery"
  value       = var.cluster_name
}
