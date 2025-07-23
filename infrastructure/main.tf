# Terraform 설정
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS 프로바이더 설정
provider "aws" {
  region = var.aws_region
}

# 네트워크 모듈 호출 (VPC, Subnet, IGW 등)
module "network" {
  source               = "./modules/network"
  name_prefix          = var.name_prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  private_subnet_cidr  = var.private_subnet_cidr
  az                   = var.az
  vpc_id               = module.network.vpc_id
  name                 = "${var.name_prefix}-igw"
  tags                 = var.default_tags
  route_tables         = var.route_tables
}

# EKS 클러스터 모듈 호출
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

# S3 모듈 호출
module "s3_bucket" {
  source                  = "./modules/s3"
  bucket_name             = var.bucket_name
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

module "rds" {
  source = "./modules/rds"  # 모듈 경로 (상황에 맞게 수정)

  name_prefix            = var.name_prefix
  environment            = var.environment

  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password

  vpc_security_group_ids = var.rds_security_group_ids
  private_subnet_ids     = var.rds_private_subnet_ids

  create_subnet_group    = var.create_subnet_group
  db_subnet_group_name   = var.db_subnet_group_name

  multi_az               = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window          = var.backup_window
  maintenance_window     = var.maintenance_window

  skip_final_snapshot    = var.skip_final_snapshot
  deletion_protection    = var.deletion_protection

  tags = var.default_tags
}
