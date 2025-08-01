# Terraform 버전 및 프로바이더 정의
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25" # 안정적인 최신 버전
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12" # 안정적인 최신 버전
    }
  }

  # backend "s3" {  # backend 설정에는 variable을 사용할 수 없으므로 하드코딩
  #   bucket         = "matchfit-terraform-loc"
  #   key            = "infrastructure/infrastructure.tfstate"
  #   region         = "ap-northeast-2"
  #   dynamodb_table = "matchfit-terraform-lock-table"
  #   encrypt        = true
  # }

}
# AWS Provider 정의
provider "aws" {
  region = var.aws_region   # 변수로부터 리전 설정 (예: ap-northeast-2)
}
# Kebernetes Provider 정의
provider "kubernetes" {
  config_path = "~/.kube/config"  # 본인 kubeconfig 경로
}
# Helm Provider 정의
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
#####################
# TFC 사용 시 필요
# terraform {
#   backend "remote" {
#     organization = "team3-matchfit"
#     workspaces {
#       name = "Final-Team3-Infra"
#     }
#   }
# }
#####################
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
  cluster_name         = var.cluster_name             # ALB 태깅

  vpc_id = module.network.vpc_id                      # 중첩된 모듈에서 vpc_id 재사용
  name   = "${var.name_prefix}-igw"                   # IGW 이름
  tags   = var.default_tags                           # 공통 태그
  route_tables = [      # 커스텀 라우팅 테이블 정보
    {
      name       = "${var.name_prefix}-private-rt"
      subnet_ids = local.private_subnet_ids
      tags       = {
        Name = "${var.name_prefix}-private-rt"
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
#####################
# EKS Admin Role 생성 및 연결 모듈 호출
module "eks_admin_role" {
  source                  = "./modules/iam"
  name_prefix             = var.name_prefix
  cluster_name            = var.cluster_name
  admin_user_arn          = var.admin_user_arn
  eks_cluster_resource    = module.eks.cluster_resource
  tags                    = var.default_tags
}
# EKS 클러스터 모듈 호출
module "eks" {
  source                     = "./modules/eks"
  create_instance_profile    = var.create_instance_profile
  cluster_name               = var.cluster_name
  kubernetes_version         = var.kubernetes_version
  vpc_id                     = module.network.vpc_id
  subnet_ids                 = module.network.private_subnet_id
  service_ipv4_cidr          = var.service_ipv4_cidr
  tags                       = var.default_tags
  worker_access_cidr         = var.worker_access_cidr
  vpn_security_group_id      = module.vpn.vpn_security_group_id

  ssh_key_name               = var.ssh_key_name       # SSH 접근용 키
}
############################
# VPN 모듈 호출
module "vpn" {
  source                      = "./modules/vpn"
  name_prefix                 = var.name_prefix
  vpc_id                      = module.network.vpc_id
  vpc_cidr                    = var.vpc_cidr
  create_security_group       = true
  client_cidr_block           = "192.168.200.0/22"       # VPN 클라이언트 IP 풀
  server_certificate_arn      = var.server_certificate_arn
  client_ca_certificate_arn   = var.client_ca_certificate_arn
  cloudwatch_log_group        = "matchfit-vpn-logs"
  subnet_ids                  = module.network.private_subnet_id
}
#####################
# RDS 모듈 호출
module "rds" {
  source = "./modules/rds"  # 모듈 경로 (상황에 맞게 수정)

  name_prefix            = var.name_prefix
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  # vpc_security_group_ids  = var.rds_security_group_ids
  vpc_security_group_ids    = []
  private_subnet_ids        = module.network.private_subnet_id

  create_security_group  = true
  vpc_id                 = module.network.vpc_id

  create_subnet_group    = var.create_subnet_group
  db_subnet_group_name   = var.db_subnet_group_name

  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  maintenance_window      = var.maintenance_window

  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = var.deletion_protection

  tags = var.default_tags
}
#####################
# ElastiCache 설정 모듈 호출
module "elasticache" {
  source             = "./modules/elasticache"
  name_prefix        = var.name_prefix                      # 리소스 네이밍 접두어(필수값)
  vpc_id             = module.network.vpc_id
  private_subnet_ids = module.network.private_subnet_id
  eks_node_sg_id     = module.eks.eks_node_sg_id            # EKS 노드의 Security Group ID (접근 허용 목적)

  auth_token                  = var.auth_token              # Redis 접속 시 필요한 인증 비밀번호

  # 설정 안할 시 AWS가 임의 시간대로 설정
  maintenance_window          = var.maintenance_window       # 정기 점검 시간
  snapshot_window             = var.snapshot_window          # 스냅샷 수행 시간대
  snapshot_retention_limit    = 1                            # 스냅샷 보관 일수

  tags = var.default_tags
}


############################
# # S3 모듈 호출
module "s3_bucket" {
  source                  = "./modules/s3"
  create_bucket           = true
  bucket_name             = var.app_bucket_name
  force_destroy           = true
  enable_versioning       = true
  enable_website          = false
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  tags                    = var.default_tags
}

#################################
# CloudFront (OAC + HTTPS)
#################################
module "cloudfront" {
  source                         = "./modules/cloudfront"
  service_name                   = var.name_prefix
  domain_name                    = var.domain_name
  cloudfront_certificate_arn     = var.cloudfront_certificate_arn
  s3_origin_domain               = module.s3_bucket.bucket_regional_domain_name  # 기존 S3 모듈의 도메인
  s3_bucket_id                   = module.s3_bucket.bucket_id                     # 기존 S3 모듈의 ID
  s3_bucket_arn                  = module.s3_bucket.bucket_arn                    # 기존 S3 모듈의 ARN
  price_class                    = var.price_class
  custom_error_responses         = var.custom_error_responses
  tags                           = var.default_tags
}
#################################
# Route53 (CloudFront 연결)
#################################
resource "aws_route53_record" "cloudfront" {
  zone_id = module.route53.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = module.cloudfront.cloudfront_domain_name
    zone_id                = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
############################
# ECR 모듈 호출
module "ecr" {
  source = "./modules/ecr"

  name_prefix        = var.name_prefix                  # 리포지토리 이름
  image_tag_mutability = var.ecr_image_tag_mutability  # 이미지 태그 수정 가능 여부
  force_delete         = var.ecr_force_delete          # 이미지가 남아있더라도 삭제 가능 여부
  scan_on_push         = var.ecr_scan_on_push          # 이미지 푸시 시 자동으로 취약점 검사 여부
  encryption_type      = var.ecr_encryption_type       # 암호화 방식
  tags = var.default_tags
}
############################
# Route53 DNS 설정 모듈 호출
module "route53" {
  source           = "./modules/route53"
  alb_zone_id      = "Z3W03O7B5YMIYP"
  domain_name      = var.domain_name
  argocd_alb_dns   = module.argocd.argocd_alb_dns
  depends_on       = [module.alb_controller]
}