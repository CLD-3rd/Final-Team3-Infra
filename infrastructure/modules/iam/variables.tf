variable "name_prefix" {
  description = "리소스 이름 접두어"
  type        = string
}
variable "admin_user_arn" {
  description = "관리자 IAM 사용자의 ARN"
  type        = string
}

variable "tags" {
  description = "상위 모듈에서 전달되는 태그 정보 (default_tags)"
  type        = map(string)
}

variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

variable "eks_admin_policy_arn" {
  description = "EKS 클러스터 관리자 액세스 정책 ARN"
  type        = string
  default     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
}
variable "eks_cluster_resource" {
  description = "The EKS cluster resource for dependency"
  type        = any
}
