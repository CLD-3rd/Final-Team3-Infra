variable "cluster_name" {
  type        = string
  description = "EKS 클러스터 이름 (ALB Controller Helm 설치 시 필요)"
}

variable "alb_controller_irsa_role_arn" {
  type        = string
  description = "ALB Controller용 IAM Role ARN (IRSA에 연결된 역할)"
}
