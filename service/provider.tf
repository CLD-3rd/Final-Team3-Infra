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

  backend "s3" {  # backend 설정에는 variable을 사용할 수 없으므로 하드코딩
    bucket         = "matchfit-terraform-loc"
    key            = "service/service.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "matchfit-terraform-lock-table"
    encrypt        = true
  }

}

# 읽기 전용, infrastructure의 output 참조
data "terraform_remote_state" "infra" {
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key 
    region = var.remote_state_region
  }
}

# AWS Provider 정의
provider "aws" {
  region = "ap-northeast-2"

  assume_role {
    role_arn = "arn:aws:iam::061039804626:role/matchfit-eks-admin-role"
  }
}


data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.infra.outputs.eks_cluster_name
}
data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.infra.outputs.eks_cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.cluster.token
  }
}