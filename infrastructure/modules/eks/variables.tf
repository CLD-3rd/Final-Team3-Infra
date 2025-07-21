# 클러스터 이름
variable "cluster_name" {
  description = "EKS 클러스터 이름"
  type        = string
}

# 쿠버네티스 버전 (예: 1.27)
variable "kubernetes_version" {
  description = "Kubernetes 버전"
  type        = string
}

# EKS가 사용할 IAM 역할 ARN
variable "cluster_role_arn" {
  description = "EKS 클러스터에 부여할 IAM 역할 ARN"
  type        = string
}

# EKS 클러스터에 연결할 서브넷 ID 목록 (프라이빗 또는 퍼블릭)
variable "subnet_ids" {
  description = "EKS 클러스터가 사용할 서브넷 ID 리스트"
  type        = list(string)
}

# 클러스터 서비스용 CIDR (선택)
variable "service_ipv4_cidr" {
  description = "Kubernetes 서비스용 IPv4 CIDR"
  type        = string
  default     = "172.20.0.0/16"
}

# 공통 태그
variable "tags" {
  description = "리소스에 부여할 태그"
  type        = map(string)
  default     = {}
}
