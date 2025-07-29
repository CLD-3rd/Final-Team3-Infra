### SG(보안그룹) 생성 관련 모듈화 main.tf ###
# EKS 관련 Security Group (클러스터, 노드그룹)
# EKS 클러스터 보안 그룹 생성
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.name_prefix}-eks-sg"
  description = "EKS Cluster SG"
  vpc_id      = var.vpc_id
  # 워커 노드 → EKS API 서버 (443포트) 통신 허용
  ingress {
    description = "Allow worker nodes to access cluster"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.worker_access_cidr
  }
  # EKS 클러스터에서 외부로 나가는 모든 통신 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${var.name_prefix}-eks-sg" }, var.tags)
}
# EKS Node 보안 그룹 생성
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.name_prefix}-eks-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id
  # 클러스터 SG에서 오는 트래픽 허용 (예: 443 포트 포함)
  ingress {
    description = "Allow cluster to communicate with nodes"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
  }
  # 노드 간 통신 허용 (same SG)
  ingress {
    description     = "Allow node to node communication"
    from_port       = 0
    to_port         = 65535
    protocol        = "tcp"
    self            = true
  }
  # VPN SG에서 오는 트래픽 허용
  ingress {
  description     = "Allow VPN SG to communicate with worker nodes"
  from_port       = 0
  to_port         = 65535
  protocol        = "tcp"
  security_groups = var.create_security_group ? [aws_security_group.vpn_sg[0].id] : [var.security_group_id]
}
  # 노드 → 외부로 나가는 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge({ Name = "${var.name_prefix}-eks-node-sg" }, var.tags)
}