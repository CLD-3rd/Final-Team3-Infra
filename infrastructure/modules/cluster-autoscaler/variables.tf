variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "cluster_oidc_url" {
  description = "EKS 클러스터 OIDC 프로바이더 URL"
  type        = string
}

variable "oidc_provider_arn" {
  description = "EKS 클러스터에 생성된 OIDC 공급자의 ARN(IAM 역할과 연결할 때 사용)"
  type        = string
}

variable "node_group_name" {
  description = "EKS 노드 그룹 이름(Cluster Autoscaler가 자동 스케일링할 대상 노드 그룹 이름)"
  type        = string
}

variable "aws_region" {
  description = "AWS 리전"
  type        = string
}

variable "tags" {
  description = "리소스에 적용할 공통 태그 맵"
  type        = map(string)
}