output "argocd_alb_dns" {
  description = "ArgoCD ALB Ingress의 DNS 이름 (호스트명)"
  value       = data.kubernetes_ingress_v1.argocd.status[0].load_balancer[0].ingress[0].hostname
}
