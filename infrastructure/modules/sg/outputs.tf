### SG(보안그룹) 생성 관련 모듈화 outputs.tf ###
# EKS 관련 Security Group (클러스터, 노드그룹)
output "eks_cluster_sg_id" {
  description = "EKS 클러스터 보안 그룹 ID"
  value = aws_security_group.eks_cluster_sg.id
}
output "eks_node_sg_id" {
  description = "EKS 노드그룹 보안 그룹 ID"
  value = aws_security_group.eks_node_sg.id
}
#####################
# VPN 관련 Security Group
output "vpn_sg_id" {
  description = "VPN 보안 그룹 ID"
  value       = var.create_security_group ? aws_security_group.vpn_sg[0].id : var.security_group_id
}
#####################
# RDS 관련 Security Group
# output "rds_sg_id" {
#   description = "RDS 보안 그룹 ID"
#   value       = var.create_security_group ? aws_security_group.rds[0].id : null
# }