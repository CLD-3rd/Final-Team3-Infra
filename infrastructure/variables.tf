variable "aws_region" {
  description = "AWS 리전"
  default     = "ap-northeast-2"
}

variable "name_prefix" {
  description = "공통 리소스 이름 접두어"
  default     = "team3"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
}

variable "az" {
  default = "ap-northeast-2a"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Owner       = "cloud-team"
  }
}

variable "route_tables" {
  description = "라우팅 테이블 설정"
  type = list(object({
    name       = string
    tags       = map(string)
    routes     = list(object({
      cidr_block     = string
      gateway_id     = optional(string)
      nat_gateway_id = optional(string)
    }))
    subnet_ids = list(string)
  }))
  default = []
}

variable "kubernetes_version" {
  default = "1.27"
}

variable "cluster_name" {
  default = "team3-eks"
}

variable "service_ipv4_cidr" {
  default = "172.20.0.0/16"
}

variable "ssh_key_name" {
  description = "EC2 인스턴스에 사용할 SSH 키 이름"
  type        = string
}

variable "worker_access_cidr" {
  description = "EKS API 접근 허용 CIDR"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}
