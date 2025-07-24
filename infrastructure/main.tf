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
locals {
  private_subnet_ids = module.network.private_subnet_id
}
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
  route_tables = [      # 커스텀 라우팅 테이블 정보
    {
      name       = "private-rt"
      subnet_ids = local.private_subnet_ids
      tags       = {
        Name = "private-rt"
      }
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          nat_gateway_id = module.network.nat_gateway_id
        }
      ]
    }
  ]
}

# EKS 클러스터 모듈 호출
module "eks" {
  source                = "./modules/eks"
  cluster_name          = var.cluster_name
  kubernetes_version    = var.kubernetes_version
  vpc_id                = module.network.vpc_id
  subnet_ids            = module.network.private_subnet_id
  service_ipv4_cidr     = var.service_ipv4_cidr
  tags                  = var.default_tags
  worker_access_cidr    = var.worker_access_cidr

  ssh_key_name = var.ssh_key_name       # SSH 접근용 키

  depends_on = [
    module.network
  ]

}

module "rds" {
  source = "./modules/rds"  # 모듈 경로 (상황에 맞게 수정)

  name_prefix            = var.name_prefix
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  # vpc_security_group_ids = var.rds_security_group_ids
  vpc_security_group_ids = []
  private_subnet_ids = module.network.private_subnet_id

  create_security_group  = true
  vpc_id                 = module.network.vpc_id

  create_subnet_group    = var.create_subnet_group
  db_subnet_group_name   = var.db_subnet_group_name

  multi_az               = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = var.deletion_protection

  tags = var.default_tags

    depends_on = [
    module.eks
  ]
}

# elasticache 설정 모듈 호출
module "elasticache" {
  source             = "./modules/elasticache"
  name               = "team3"                              # 리소스 네이밍 접두어(필수값)
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_id
  eks_node_sg_id     = module.eks.eks_node_sg_id            # EKS 노드의 Security Group ID (접근 허용 목적)

  auth_token                  = var.auth_token              # Redis 접속 시 필요한 인증 비밀번호

  # 설정 안할 시 AWS가 임의 시간대로 설정
  maintenance_window          = "mon:03:00-mon:04:00"       # 정기 점검 시간
  snapshot_window             = "00:00-04:00"               # 스냅샷 수행 시간대
  snapshot_retention_limit    = 1                           # 스냅샷 보관 일수

  tags = var.default_tags
}

# S3 모듈 호출
module "s3_bucket" {
  source                  = "./modules/s3"
  bucket_name             = var.bucket_name
  force_destroy           = var.force_destroy         # 추가: 버킷 삭제 동작 제어
  enable_versioning       = var.enable_versioning
  enable_website          = var.enable_website
  index_document          = var.index_document
  error_document          = var.error_document
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  bucket_policy           = var.bucket_policy
  tags                    = var.default_tags
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy   # true면 객체 포함 강제 삭제
  tags          = var.default_tags
}
