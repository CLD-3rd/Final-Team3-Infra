# 기본 설정
variable "aws_region" {
  description = "AWS Region"
  default     = "ap-northeast-2"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  default     = "team1"
}

# 네트워크
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block for VPC"
}

variable "public_subnet_cidr" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnet_cidr" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

variable "az" {
  description = "Availability zones"
  type        = list(string)
}

variable "default_tags" {
  description = "Default tags for all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Owner       = "cloud-team"
  }
}

# 라우팅 테이블 구성
variable "route_tables" {
  description = "Custom route table definition"
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

# EKS 관련
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
  description = "SSH key pair name for EKS worker nodes"
  type        = string
}

variable "worker_access_cidr" {
  description = "CIDRs allowed to access EKS API"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

# S3 관련 변수들
variable "bucket_name" {
  description = "Name of the S3 bucket (globally unique)"
  type        = string
}

variable "enable_versioning" {
  type    = bool
  default = false
}

variable "enable_website" {
  type    = bool
  default = false
}

variable "index_document" {
  type    = string
  default = "index.html"
}

variable "error_document" {
  type    = string
  default = "error.html"
}

variable "block_public_acls" {
  type    = bool
  default = true
}

variable "block_public_policy" {
  type    = bool
  default = true
}

variable "ignore_public_acls" {
  type    = bool
  default = true
}

variable "restrict_public_buckets" {
  type    = bool
  default = true
}

variable "bucket_policy" {
  description = "Optional S3 Bucket Policy (JSON object)"
  type        = any
  default     = null
}
