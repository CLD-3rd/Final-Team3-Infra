# Terraform 버전 및 프로바이더 정의
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# AWS Provider 정의
provider "aws" {
  region = var.aws_region   # 변수로부터 리전 설정 (예: ap-northeast-2)
}

# network 설정 모듈 호출
module "network" {
  source               = "./modules/network"                  # 모듈 경로
  name_prefix          = var.name_prefix              # 접두어
  vpc_cidr             = var.vpc_cidr                 # VPC CIDR
  public_subnet_cidr   = var.public_subnet_cidr       # 퍼블릭 서브넷 CIDR
  private_subnet_cidr  = var.private_subnet_cidr      # 프라이빗 서브넷 CIDR
  az                   = var.az                       # 가용 영역

  vpc_id = module.network.vpc_id                      # 중첩된 모듈에서 vpc_id 재사용
  name   = "${var.name_prefix}-igw"                   # IGW 이름
  tags   = var.default_tags                           # 공통 태그
  route_tables = var.route_tables                     # 커스텀 라우팅 테이블 정보
}

# EKS 관련 IAM 모듈 호출


# EKS 설정 모듈 호출
module "eks" {
  source                = "./modules/eks"
  cluster_name          = var.cluster_name
  kubernetes_version    = var.kubernetes_version
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.private_subnet_id
  service_ipv4_cidr     = var.service_ipv4_cidr
  ssh_key_name          = var.ssh_key_name
  tags                  = var.default_tags
  worker_access_cidr    = var.worker_access_cidr
}

