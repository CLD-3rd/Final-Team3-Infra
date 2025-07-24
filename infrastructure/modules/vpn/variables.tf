variable "name_prefix" {
  description = "이름 prefix"
  type        = string
}

variable "server_certificate_arn" {
  description = "Server certificate ARN from ACM"
  type        = string
}

variable "client_ca_certificate_arn" {
  description = "Client root certificate ARN from ACM"
  type        = string
}

variable "client_cidr_block" {
  description = "Client CIDR block (e.g. 172.31.0.0/22)"
  type        = string
  default = "192.168.200.0/22"
}

variable "subnet_ids" {
  description = "List of subnet IDs to associate with VPN"
  type        = list(string)
}

variable "cloudwatch_log_group" {
  type = string
}

variable "cloudwatch_log_stream" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "create_security_group" {
  type    = bool
  default = true
}

variable "security_group_id" {
  type        = string
  description = "기존 SG를 사용할 경우 입력"
  default     = null
}
