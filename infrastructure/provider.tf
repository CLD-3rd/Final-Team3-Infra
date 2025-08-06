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
    key            = "infrastructure/infrastructure.tfstate"
    region         = "ap-northeast-2"
    dynamodb_table = "matchfit-terraform-lock-table"
    encrypt        = true
  }

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
#     organization = "team3-matchfit-test"
#     workspaces {
#       name = "Final-Team3-Infra"
#     }
#   }
# }