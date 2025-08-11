variable "cluster_name" {
  type        = string
  description = "ALB Controller Helm 차트 설치 시 필요한 EKS 클러스터 이름"
}

variable "alb_irsa_role_arn" {
  type        = string
  description = "ALB Controller가 사용할 IAM 역할의 ARN (IRSA에 연결된 역할)"
}
variable "vpc_id" {
  type = string
}