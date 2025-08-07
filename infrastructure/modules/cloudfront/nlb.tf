# 변수
variable "vpc_id" {}
variable "public_subnet_id" {
  type = list(string)
}
# variable "eks_node_sg_id" {}
variable "cluster_name" {}

##################################
# NLB 생성 (퍼블릭 서브넷에)
##################################
resource "aws_lb" "eks_nlb" {
  name               = "${var.service_name}-eks-public-nlb"
  internal           = false   # 퍼블릭용이라 false
  load_balancer_type = "network"
  subnets            = var.public_subnet_id

  enable_deletion_protection = false

  tags = {
    Name = "eks-public-nlb"
  }
}
##################################
# 타겟 그룹 생성 (EKS NodePort 포트로 트래픽 전달)
##################################
resource "aws_lb_target_group" "eks_targets" {
  name     = "${var.service_name}-eks-targets"
  port     = 30080        # EKS 서비스 NodePort (예시)
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol            = "TCP"
    port                = "30080"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 10
    interval            = 30
  }

  tags = {
    Name = "${var.service_name}-eks-target-group"
  }
}

##################################
# 타겟 그룹에 EKS 노드 등록
##################################
resource "aws_lb_target_group_attachment" "eks_node_attachment" {
  count            = length(data.aws_instances.eks_nodes.ids)
  target_group_arn = aws_lb_target_group.eks_targets.arn
  target_id        = data.aws_instances.eks_nodes.ids[count.index]
  port             = 30080  # NodePort와 동일
}

##################################
# 리스너 생성 (NLB에 80 포트로 열기)
##################################
resource "aws_lb_listener" "eks_listener" {
  load_balancer_arn = aws_lb.eks_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_targets.arn
  }
}

##################################
# EKS 노드 정보 가져오기 (예시)
##################################
data "aws_instances" "eks_nodes" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [var.cluster_name]
  }

  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
}

# aws_lb.eks_nlb: 퍼블릭 서브넷에 NLB 생성
# aws_lb_target_group.eks_targets: EKS NodePort 서비스가 열려있는 포트 (30080)로 트래픽 전달
# aws_lb_target_group_attachment.eks_node_attachment: 현재 실행 중인 EKS 노드들을 타겟으로 등록
# aws_lb_listener.eks_listener: 80 포트 TCP로 리스너 생성, 타겟 그룹으로 포워딩
# data.aws_instances.eks_nodes: 태그 기반으로 EKS 노드 인스턴스 목록 조회 (클러스터명 변수 필요)