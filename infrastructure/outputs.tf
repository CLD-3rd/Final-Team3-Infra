# VPC ID 출력
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}
# 퍼블릭 서브넷 ID 출력
output "public_subnet_id" {
  description = "모듈에서 생성한 퍼블릭 서브넷 ID"
  value       = module.network.public_subnet_id
}
# 프라이빗 서브넷 ID 출력
output "private_subnet_id" {
  description = "모듈에서 생성한 프라이빗 서브넷 ID"
  value       = module.network.private_subnet_id
}
# IGW ID 출력
output "igw_id" {
  description = "모듈에서 생성한 인터넷 게이트웨이 ID"
  value       = module.network.igw_id
}
# 커스텀 라우팅 테이블 ID 리스트 출력
output "custom_route_table_ids" {
  description = "모듈에서 생성한 사용자 정의 라우팅 테이블 ID 목록"
  value       = module.network.custom_route_table_ids
}

# EKS 관련 루트 outputs
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
