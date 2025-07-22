terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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

