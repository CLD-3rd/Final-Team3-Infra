# ALB
output "alb_irsa_role_arn" {
  description = "ALB Controller가 사용할 IAM 역할의 ARN (IRSA 역할)"
  value       = aws_iam_role.alb_controller_irsa.arn
}

# Grafana
output "grafana_irsa_role_name" {
  value = aws_iam_role.grafana_irsa.name
}
output "grafana_irsa_role_arn" {
  value       = aws_iam_role.grafana_irsa.arn
  description = "IAM role ARN used by Grafana"
}
output "grafana_service_account" {
  value       = kubernetes_service_account.grafana_sa.metadata[0].name
  description = "Service account for Grafana"
}

#FluentBit
output "fluentbit_irsa_role_arn" {
  value       = aws_iam_role.fluentbit_irsa.arn
  description = "IAM role ARN used by Fluent Bit"
}
output "fluentbit_service_account" {
  value       = kubernetes_service_account.fluentbit_sa.metadata[0].name
  description = "Service account for Fluent Bit"
}

#Prometheus
output "prometheus_irsa_role_arn" {
  value       = aws_iam_role.prometheus_irsa.arn
  description = "IAM role ARN used by Prometheus"
}
output "prometheus_service_account" {
  value       = kubernetes_service_account.prometheus_sa.metadata[0].name
  description = "Service account for Prometheus"
}

# External DNS
output "externaldns_irsa_role_arn" {
  value       = aws_iam_role.externaldns_irsa.arn
  description = "IAM role ARN used by ExternalDNS"
}

#
output "cloudwatchexporter_irsa_role_arn" {
  value       = aws_iam_role.cloudwatchexporter_irsa.arn
  description = "IAM role ARN used by CloudWatch Exporter"
}

output "cloudwatchexporter_service_account" {
  value       = kubernetes_service_account.cloudwatchexporter_sa.metadata[0].name
  description = "Service account for CloudWatch Exporter"
}
