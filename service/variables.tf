variable "remote_state_bucket" {
  type        = string
  description = "infrastructure의 tfstate가 저장된 S3 버킷 이름"
  default     = "matchfit-terraform-loc"
}

variable "remote_state_key" {
  type        = string
  description = "infrastructure의 tfstate 파일 경로"
  default     = "infrastructure/infrastructure.tfstate"
}

variable "remote_state_region" {
  type        = string
  description = "infrastructure의 tfstate가 저장된 AWS 리전"
  default     = "ap-northeast-2"
}
#####################
# Route53 관련 루트 변수
variable "domain_name" {
  description = "Route53 도메인 이름"
  type        = string
}

# CA 조건부 생성 변수
variable "create_cluster_autoscaler" {
  description = "false 시 CA 비활성화"
  type        = bool
  default     = false
}