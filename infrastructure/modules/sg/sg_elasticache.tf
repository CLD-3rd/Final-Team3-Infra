# Redis 클러스터가 배치될 서브넷 그룹 정의
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name_prefix}-subnet-group"
  subnet_ids = var.private_subnet_ids
}

# Redis에 접근하기 위한 보안 그룹 설정
resource "aws_security_group" "this" {
  name        = "${var.name_prefix}-sg"
  description = "Security group for Redis ElastiCache"
  vpc_id      = var.vpc_id

  # EKS 노드로부터 Redis에 대한 접근 허용 (Ingress)
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  # Redis가 응답을 돌려보내기 위한 egress 설정 (동일 SG만 허용)
  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    security_groups = [var.eks_node_sg_id]
  }
}