variable "name_prefix" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {}
}
variable "cluster_name" {
  type = string
}
variable "eks_oidc_arn" {
  type        = string
  description = "OIDC provider ARN from EKS cluster"
}
variable "eks_oidc_url" {
  type        = string
  description = "OIDC provider URL from EKS cluster"
}
variable "monitoring_namespace" {
  type        = string
  default     = "monitoring"
  description = "Namespace for monitoring components"
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

<<<<<<< HEAD
# Backend S3 Access IRSA
variable "image_bucket_name" {
  type = string
}
variable "backend_namespace" {
  type = string
  default = "argocd"
}
variable "backend_service_account" {
  type = string
  default = "backend-sa"
}
=======
# CloudWatch Exporter-specific
variable "cloudwatchexporter_policy_name" {
  type        = string
  default     = "CloudWatchExporterReadOnly"
  description = "IAM policy name for CloudWatch Exporter"
}

variable "cloudwatchexporter_service_account" {
  type        = string
  default     = "cloudwatchexporter-sa"
  description = "Service account name for CloudWatch Exporter"
}
>>>>>>> 127309eba036042717173761bb271a467d3b3db6
