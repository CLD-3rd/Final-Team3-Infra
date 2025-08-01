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

#####################
# AWS Provider 정의
provider "aws" {
  region = var.aws_region
}

############################
# # S3 모듈 호출
module "s3_bucket" {
  source                  = "./modules/s3-state"
  create_bucket           = var.create_bucket
  bucket_name             = var.bucket_name
  force_destroy           = var.force_destroy
  enable_versioning       = var.enable_versioning
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
  tags                    = var.default_tags
}

############################
# DynamoDB 모듈 호출
module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table_name
  tags       = var.default_tags
}
