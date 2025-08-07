variable "name_prefix" {
  type = string
}
variable "cluster_name" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {}
}

variable "monitoring_namespace" {
  type        = string
  default     = "monitoring"
  description = "Namespace for monitoring components"
}

variable "eks_oidc_arn" {
  type        = string
  description = "OIDC provider ARN from EKS cluster"
}

variable "eks_oidc_url" {
  type        = string
  description = "OIDC provider URL from EKS cluster"
}

# Grafana-specific
variable "grafana_policy_name" {
  type        = string
  default     = "GrafanaCloudWatchReadOnly"
}
variable "grafana_service_account" {
  type        = string
  default     = "grafana-sa"
}

# Fluent Bit-specific
variable "fluentbit_policy_name" {
  type        = string
  default     = "FluentBitCloudWatchWriteOnly"
}
variable "fluentbit_service_account" {
  type        = string
  default     = "fluentbit-sa"
}

# Prometheus-specific
variable "prometheus_policy_name" {
  type        = string
  default     = "PrometheusCloudWatchReadOnly"
}
variable "prometheus_service_account" {
  type        = string
  default     = "prometheus-sa"
}

# ExternalDNS-specific
variable "externaldns_namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace for externaldns components"
}

variable "externaldns_policy_name" {
  type        = string
  default = "externaldns-policy"
}

variable "externaldns_service_account" {
  type        = string
  default     = "externaldns-sa"
}