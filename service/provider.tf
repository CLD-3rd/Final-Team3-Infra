# Terraform 버전 및 프로바이더 정의
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
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

# AWS Provider 정의
provider "aws" {
  region = "ap-northeast-2"
}

data "terraform_remote_state" "infra" {     # 읽기 전용, infrastructure의 output 참조
  backend = "s3"
  config = {
    bucket = var.remote_state_bucket
    key    = var.remote_state_key 
    region = var.remote_state_region
  }
}