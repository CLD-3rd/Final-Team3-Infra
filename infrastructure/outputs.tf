# VPC 및 서브넷 출력
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.network.private_subnet_id
}

output "igw_id" {
  description = "ID of the internet gateway"
  value       = module.network.igw_id
}

output "custom_route_table_ids" {
  description = "List of route table IDs"
  value       = module.network.custom_route_table_ids
}

# EKS 출력
output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS Cluster name"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "EKS Cluster API endpoint"
}

output "eks_cluster_ca" {
  value       = module.eks.cluster_certificate_authority
  description = "EKS Cluster certificate authority"
}

output "eks_cluster_id" {
  value       = module.eks.cluster_id
  description = "EKS cluster ID"
}

output "eks_cluster_role_arn" {
  value       = module.eks.eks_cluster_role_arn
  description = "IAM Role ARN for EKS Cluster"
}

output "eks_node_role_arn" {
  value       = module.eks.eks_node_role_arn
  description = "IAM Role ARN for EKS NodeGroup"
}

output "eks_node_instance_profile" {
  value       = module.eks.eks_node_instance_profile
  description = "EC2 Instance Profile for EKS Nodes"
}

output "cluster_sg_id" {
  value       = module.eks.cluster_sg_id
  description = "EKS Cluster security group ID"
}

output "node_group_name" {
  value       = module.eks.node_group_name
  description = "EKS NodeGroup name"
}


# RDS 출력
output "rds_endpoint" {
  description = "RDS 접속 엔드포인트"
  value       = module.rds.rds_endpoint
  sensitive   = true
}
output "rds_identifier" {
  description = "RDS 인스턴스 식별자"
  value       = module.rds.rds_identifier
}
output "rds_port" {
  description = "RDS 포트 번호"
  value       = module.rds.rds_port
}
output "rds_address" {
  description = "RDS 호스트 이름"
  value       = module.rds.rds_address
  sensitive   = true
}
