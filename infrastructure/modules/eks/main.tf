# EKS 클러스터용 IAM 역할 생성
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"  # IAM 역할 이름

  # EKS 서비스가 이 역할을 사용할 수 있도록 신뢰 정책 구성
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags  # 공통 태그 적용
}

# EKS 클러스터용 IAM 정책 연결
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}
resource "aws_iam_role_policy_attachment" "eks_vpc_controller_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}


# EKS 노드 그룹용 IAM 역할 생성
resource "aws_iam_role" "eks_node_role" {
  name = "${var.cluster_name}-node-role"

  # EC2 인스턴스가 이 역할을 사용할 수 있도록 신뢰 정책 구성
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

# 노드 그룹에 필요한 IAM 정책 연결
resource "aws_iam_role_policy_attachment" "eks_worker_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"  # EKS API 통신
}
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"       # VPC 네트워크 연동
}
resource "aws_iam_role_policy_attachment" "eks_registry_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"   # ECR 이미지 Pull
}
resource "aws_iam_role_policy_attachment" "ssm_core_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore" #SSM 세션 매니저 연결을 위한 권한
}


# EC2 인스턴스 프로파일 생성 (노드 그룹에서 사용)
resource "aws_iam_instance_profile" "eks_node_instance_profile" {
  name = "${var.cluster_name}-node-instance-profile"
  role = aws_iam_role.eks_node_role.name
}

# EKS 클러스터 보안 그룹 생성
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-sg"
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

  tags = merge({ Name = "${var.cluster_name}-sg" }, var.tags)
}
# EKS Node 보안 그룹 생성
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg"
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

  # 노드 → 외부로 나가는 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.cluster_name}-node-sg" }, var.tags)
}
# EKS Node ssh Access 그룹 생성
resource "aws_security_group" "eks_ssh_sg" {
  name        = "${var.cluster_name}-node-ssh-sg"
  description = "SSH access for EKS nodes"
  vpc_id      = var.vpc_id

  ingress {
    description      = "Allow SSH from VPN Endpoint"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["192.168.200.0/22"]   # VPN의 CIDR
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ Name = "${var.cluster_name}-node-ssh-sg" }, var.tags)
}

# EKS 클러스터 생성
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name                       # 클러스터 이름
  version  = var.kubernetes_version                 # 쿠버네티스 버전
  role_arn = aws_iam_role.eks_cluster_role.arn     # 클러스터용 IAM 역할

  vpc_config {
    subnet_ids              = var.subnet_ids                         # 클러스터에 연결할 서브넷들
    security_group_ids      = [aws_security_group.eks_cluster_sg.id] # 보안 그룹 ID
    endpoint_private_access = true                                   # 프라이빗 접근만 허용
    endpoint_public_access  = false                                  # 퍼블릭 접근 비활성화
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr        # 클러스터 내부 서비스용 CIDR
  }

  tags = merge({ Name = var.cluster_name }, var.tags)
}

# EKS 노드 그룹 생성
resource "aws_eks_node_group" "default" {
  cluster_name    = aws_eks_cluster.this.name                    # 연결할 EKS 클러스터 이름
  node_group_name = "${var.cluster_name}-node-group"             # 노드 그룹 이름
  node_role_arn   = aws_iam_role.eks_node_role.arn               # 노드 그룹에 할당할 IAM 역할
  subnet_ids      = var.subnet_ids                               # 노드를 배치할 서브넷 ID들
  
  scaling_config {
    desired_size = 2     # 기본 노드 수
    max_size     = 3     # 최대 확장 수
    min_size     = 1     # 최소 유지 수
  }

  instance_types = ["t2.micro"]         # 노드 인스턴스 타입
  ami_type       = "AL2_x86_64"          # Amazon Linux 2 AMI

  tags = var.tags

  remote_access {
    ec2_ssh_key = var.ssh_key_name
    source_security_group_ids = [aws_security_group.eks_ssh_sg.id]   # 노드 보안그룹 ID
  }
}