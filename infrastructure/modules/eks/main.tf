# EKS 클러스터 생성
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name                            # 클러스터 이름
  version  = var.kubernetes_version                      # 쿠버네티스 버전
  role_arn = var.cluster_role_arn                        # EKS 클러스터용 IAM 역할

  vpc_config {
    subnet_ids = var.subnet_ids                          # 클러스터에 연결할 서브넷 목록
    endpoint_private_access = false                      # EKS API 서버에 Private 접근 비활성화
    endpoint_public_access  = true                       # EKS API 서버에 Public 접근 활성화
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr            # 서비스용 CIDR (선택)
  }

  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags
  )
}
