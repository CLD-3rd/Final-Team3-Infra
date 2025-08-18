variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "eks_oidc_url" {
  description = "EKS 클러스터 OIDC 프로바이더 URL"
  type        = string
}

variable "eks_oidc_arn" {
  description = "EKS 클러스터에 생성된 OIDC 공급자의 ARN(IAM 역할과 연결할 때 사용)"
  type        = string
}

variable "node_group_name" {
  description = "EKS 노드 그룹 이름(Cluster Autoscaler가 자동 스케일링할 대상 노드 그룹 이름)"
  type        = string
}

variable "region" {
  description = "AWS 리전"
  type        = string
}

variable "tags" {
  description = "리소스에 적용할 공통 태그 맵"
  type        = map(string)
}

# Cluster Autoscaler 비활성화용
variable "create_cluster_autoscaler" {
  description = "Cluster Autoscaler 비활성화용 토글(사용 시 true)"
  type    = bool
  default = false
}