variable "oidc_provider_arn" {
  description = "EKS 클러스터의 OIDC Provider ARN (IRSA 용도)"
  type        = string
}

variable "oidc_provider_url" {
  description = "EKS 클러스터의 OIDC Provider URL (IRSA 용도)"
  type        = string
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "tags" {
  description = "리소스에 적용할 태그 맵"
  type        = map(string)
}
