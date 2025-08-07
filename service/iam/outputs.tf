#
output "grafana_irsa_role_arn" {
  value       = aws_iam_role.grafana_irsa.arn
  description = "IAM role ARN used by Grafana"
}
output "grafana_service_account" {
  value       = kubernetes_service_account.grafana_sa.metadata[0].name
  description = "Service account for Grafana"
}

#
output "fluentbit_irsa_role_arn" {
  value       = aws_iam_role.fluentbit_irsa.arn
  description = "IAM role ARN used by Fluent Bit"
}
output "fluentbit_service_account" {
  value       = kubernetes_service_account.fluentbit_sa.metadata[0].name
  description = "Service account for Fluent Bit"
}

#
output "prometheus_irsa_role_arn" {
  value       = aws_iam_role.prometheus_irsa.arn
  description = "IAM role ARN used by Prometheus"
}
output "prometheus_service_account" {
  value       = kubernetes_service_account.prometheus_sa.metadata[0].name
  description = "Service account for Prometheus"
}

#
output "externaldns_irsa_role_arn" {
  value       = aws_iam_role.externaldns_irsa.arn
  description = "IAM role ARN used by ExternalDNS"
}