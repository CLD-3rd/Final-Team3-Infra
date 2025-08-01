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