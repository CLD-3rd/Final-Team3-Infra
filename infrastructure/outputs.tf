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

# S3 출력
output "s3_bucket_id" {
  value       = module.s3_bucket.bucket_id
  description = "S3 Bucket ID"
}

output "s3_bucket_arn" {
  value       = module.s3_bucket.bucket_arn
  description = "S3 Bucket ARN"
}

output "s3_bucket_domain" {
  value       = module.s3_bucket.bucket_domain_name
  description = "S3 Bucket domain name"
}

output "s3_bucket_regional_domain" {
  value       = module.s3_bucket.bucket_regional_domain_name
  description = "S3 Bucket regional domain name"
}

output "s3_website_endpoint" {
  value       = module.s3_bucket.website_endpoint
  description = "S3 website endpoint (if enabled)"
}

output "s3_website_domain" {
  value       = module.s3_bucket.website_domain
  description = "S3 website domain (if enabled)"
}
