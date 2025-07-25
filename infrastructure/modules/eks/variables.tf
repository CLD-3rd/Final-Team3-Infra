variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "service_ipv4_cidr" {
  default = "172.20.0.0/16"
}

variable "ssh_key_name" {
  type        = string
  description = "EC2 SSH key pair name for remote access"
}

variable "tags" {
  type = map(string)
}

variable "worker_access_cidr" {
  description = "Node → API 서버 허용 CIDR"
  type = list(string)
}


