output "vpc_id" {
  description = "모듈에서 생성한 VPC ID"
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "퍼블릭 서브넷 ID"
  value       = module.network.public_subnet_id
}

output "private_subnet_id" {
  description = "프라이빗 서브넷 ID"
  value       = module.network.private_subnet_id
}

output "igw_id" {
  description = "인터넷 게이트웨이 ID"
  value       = module.network.igw_id
}

output "custom_route_table_ids" {
  description = "사용자 정의 라우팅 테이블 ID 목록"
  value       = module.network.custom_route_table_ids
}

output "eks_cluster_name" {
  description = "EKS 클러스터 이름"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS API 서버 엔드포인트"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_ca" {
  description = "EKS 클러스터 인증서 정보"
  value       = module.eks.cluster_certificate_authority
}

output "eks_cluster_id" {
  description = "EKS 클러스터의 리소스 ID"
  value       = module.eks.cluster_id
}

output "eks_cluster_role_arn" {
  description = "EKS 클러스터 IAM 역할 ARN"
  value       = module.eks.eks_cluster_role_arn
}

output "eks_node_role_arn" {
  description = "EKS 노드 IAM 역할 ARN"
  value       = module.eks.eks_node_role_arn
}

output "eks_node_instance_profile" {
  description = "EKS 노드 EC2 인스턴스 프로파일 이름"
  value       = module.eks.eks_node_instance_profile
}

output "cluster_sg_id" {
  description = "EKS 클러스터 보안 그룹 ID"
  value       = module.eks.cluster_sg_id
}

output "node_group_name" {
  description = "EKS 노드 그룹 이름"
  value       = module.eks.node_group_name
}
