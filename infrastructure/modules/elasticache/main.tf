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

# Redis 클러스터 리소스 생성
resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.name_prefix}-redis-rg"          # 고유 ID
  description = "Redis replication group for ${var.name_prefix}"

  engine                       = "redis"                          # Redis 사용
  engine_version               = var.engine_version               # Redis 버전
  node_type                    = var.node_type                    # 인스턴스 타입

  automatic_failover_enabled  = var.automatic_failover_enabled    # 마스터 장애 발생 시 자동 장애조치
  num_node_groups             = 1                                 # 샤딩 사용 안 하므로 1
  replicas_per_node_group     = var.replicas_per_node_group       # 노드 그룹 당 replica 수

  parameter_group_name        = var.parameter_group_name               # Redis 파라미터 그룹 이름
  port                        = var.port                               # Redis 클러스터 포트 (기본값: 6379)
  subnet_group_name           = aws_elasticache_subnet_group.this.name # Redis를 배치할 서브넷 그룹 이름 (프라이빗 서브넷 내 배치)
  security_group_ids          = [aws_security_group.this.id]           # Redis 접근을 허용할 보안 그룹 ID 목록

  maintenance_window       = var.maintenance_window              # 정기 점검(패치) 시간대 설정
  snapshot_retention_limit = var.snapshot_retention_limit        # 자동 백업 스냅샷 보관 기간 (일 단위)
  snapshot_window          = var.snapshot_window                 # 스냅샷이 생성될 수 있는 시간대

  transit_encryption_enabled  = true
  auth_token                  = var.auth_token                   # 인증 비밀번호 설정

  tags = var.tags

}