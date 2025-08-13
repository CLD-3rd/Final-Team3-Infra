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
module "iam" {
  source                     = "./modules/iam"
  name_prefix                = var.name_prefix
  cluster_name               = var.cluster_name
  admin_user_arn             = var.admin_user_arn
  eks_cluster_resource       = module.eks.cluster_resource
  tags                       = var.default_tags
}
#####################
# EKS 클러스터 모듈 호출
module "eks" {
  source                     = "./modules/eks"
  create_instance_profile    = var.create_instance_profile
  cluster_name               = var.cluster_name
  kubernetes_version         = var.kubernetes_version
  vpc_id                     = module.network.vpc_id
  vpc_cidr                   = module.network.vpc_cidr
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
  vpn_security_group_id      = module.vpn.vpn_security_group_id
  vpc_security_group_ids    = []
  private_subnet_ids        = module.network.private_subnet_id
  eks_node_sg_id            = module.eks.eks_node_sg_id

  create_security_group  = true
  vpc_id                 = module.network.vpc_id
  vpc_cidr               = module.network.vpc_cidr

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
  source                      = "./modules/elasticache"
  name_prefix                 = var.name_prefix             # 리소스 네이밍 접두어(필수값)
  vpc_id                      = module.network.vpc_id
  vpc_cidr                    = module.network.vpc_cidr
  private_subnet_ids          = module.network.private_subnet_id
  eks_node_sg_id              = module.eks.eks_node_sg_id   # EKS 노드의 Security Group ID (접근 허용 목적)
  auth_token                  = var.auth_token              # Redis 접속 시 필요한 인증 비밀번호
  # 설정 안할 시 AWS가 임의 시간대로 설정
  maintenance_window          = var.maintenance_window      # 정기 점검 시간
  snapshot_window             = var.snapshot_window         # 스냅샷 수행 시간대
  snapshot_retention_limit    = 1                           # 스냅샷 보관 일수
  tags = var.default_tags
}
###########################
# ECR 모듈 호출
module "ecr" {
  source = "./modules/ecr"

  name_prefix          = var.name_prefix                  # 리포지토리 이름
  image_tag_mutability = var.ecr_image_tag_mutability  # 이미지 태그 수정 가능 여부
  force_delete         = var.ecr_force_delete          # 이미지가 남아있더라도 삭제 가능 여부
  scan_on_push         = var.ecr_scan_on_push          # 이미지 푸시 시 자동으로 취약점 검사 여부
  encryption_type      = var.ecr_encryption_type       # 암호화 방식
  tags = var.default_tags
}
###########################
# S3 모듈 호출
# CloudFront용 S3
module "s3_bucket" {
  source                  = "./modules/s3"
  create_bucket           = true
  bucket_name             = var.app_bucket_name
  force_destroy           = true
  enable_versioning       = true
  enable_website          = false
  # 퍼블릭 접근 권한 비활성화
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  tags                    = var.default_tags
}
# 이미지 저장용 S3 
module "public_bucket" {
  source            = "./modules/s3"
  bucket_name       = var.image_bucket_name
  is_public         = true    #퍼블릭 읽기 정책 자동 생성
  force_destroy     = true
  enable_versioning = false
  enable_website    = true
  index_document    = "index.html"
  error_document    = "error.html"
  tags              = merge(var.default_tags, { Purpose = "Public" })
  # 퍼블릭 접근 권한 활성화
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}
#################################
# CloudWatch 관련 알람
# SNS Topic
module "sns_topic" {
  source             = "./modules/alarms/sns_topic"
  name_prefix        = var.name_prefix
  # tags               = var.default_tags
}
# AWS 리소스 별 CloudWatch Alarms
module "alarms" {
  source                    = "./modules/alarms"
  name_prefix               = var.name_prefix
  redis_replica_group_id    = module.elasticache.redis_replica_group_id
  rds_instance_id           = module.rds.db_instance_id
  nat_gateway_id            = module.network.nat_gateway_id
  sns_topic_arn             = module.sns_topic.sns_topic_arn
  tags                      = var.default_tags
  depends_on      = [
    module.sns_topic, module.network, module.rds, module.elasticache
  ]
}