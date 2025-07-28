variable "oidc_provider_arn" {
  description = "IRSA를 위한 OIDC Provider의 ARN"
  type        = string
}

variable "oidc_provider_url" {
  description = "IRSA를 위한 OIDC Provider의 URL"
  type        = string
}

variable "cluster_name" {
  type        = string
}

variable "tags" {
  type = map(string)
}