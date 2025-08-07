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
#########################################################
# IAM 역할 관련 모듈 variables.tf
# EKS 관련 IAM 역할 변수
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
#########################################################
# S3 Object 접근 관련 IAM역할 변수
variable "cloudfront_log_bucket_name" {
  type        = string
}
variable "nlb_log_bucket_name" {
  type        = string
}
variable "image_bucket_name" {
  type        = string
}