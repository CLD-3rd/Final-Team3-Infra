# 클러스터 이름 출력
output "cluster_name" {
  description = "생성된 EKS 클러스터 이름"
  value       = aws_eks_cluster.this.name
}

# 클러스터 엔드포인트 출력
output "cluster_endpoint" {
  description = "EKS API 서버 엔드포인트"
  value       = aws_eks_cluster.this.endpoint
}

# 클러스터 인증 정보 출력
output "cluster_certificate_authority" {
  description = "클러스터 인증서 정보 (kubectl 설정 시 필요)"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

# 클러스터 ID
output "cluster_id" {
  description = "클러스터 ID"
  value       = aws_eks_cluster.this.id
}
