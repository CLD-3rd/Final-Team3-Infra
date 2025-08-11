output "aws_region" {
  description = "Prefix used for naming resources"
  value       = var.aws_region
}
output "name_prefix" {
  description = "Prefix used for naming resources"
  value       = var.name_prefix
}
output "default_tags" {
  description = "Prefix used for naming resources"
  value       = var.default_tags
}
#####################
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
#####################
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
output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
#####################
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
#####################
# ECR 출력
output "ecr_repository_url" {
  description = "생성된 ECR 리포지토리의 URL 출력 (이미지 push/pull 시 사용)"
  value = module.ecr.repository_url
}
output "ecr_repository_arn" {
  description = "생성된 ECR 리포지토리의 ARN 출력 (IAM 정책에 활용)"
  value = module.ecr.repository_arn
}
#####################
# S3 버킷 정보 출력
output "s3_bucket_id" {
  description = "The ID of the created S3 bucket"
  value       = module.s3_bucket.bucket_id
}
output "s3_bucket_arn" {
  description = "The ARN of the created S3 bucket"
  value       = module.s3_bucket.bucket_arn
}
output "s3_bucket_domain" {
  description = "The domain name of the created S3 bucket"
  value       = module.s3_bucket.bucket_domain_name
}
output "s3_bucket_regional_domain" {
  description = "The regional domain name of the bucket"
  value       = module.s3_bucket.bucket_regional_domain_name
}
output "s3_website_endpoint" {
  description = "S3 static website endpoint (if enabled)"
  value       = module.s3_bucket.website_endpoint
}
output "s3_website_domain" {
  description = "S3 static website domain (if enabled)"
  value       = module.s3_bucket.website_domain
}
output "bucket_id" {
  description = "웹/백엔드 통합 S3 버킷 ID"
  value       = module.s3_bucket.bucket_id
}
output "bucket_arn" {
  description = "웹/백엔드 통합 S3 버킷 ARN"
  value       = module.s3_bucket.bucket_arn
}
output "bucket_regional_domain_name" {
  description = "웹/백엔드 통합 S3 버킷 리전별 도메인"
  value       = module.s3_bucket.bucket_regional_domain_name
}
output "app_bucket_name" {
  description = "CloudFront용 S3 버킷"
  value       = var.app_bucket_name
}
output "image_bucket_name" {
  description = "CloudFront용 S3 버킷"
  value       = var.image_bucket_name
}