terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"               # AWS provider 버전 지정
    }
  }
  required_version = ">= 1.5.0"       # Terraform 최소 버전
}

provider "aws" {
  region = var.aws_region             # 사용할 AWS 리전
}

#VPC 생성
module "vpc" {
  source     = "./modules/network/vpc"   # vpc 모듈 경로
  name       = "${var.name_prefix}-vpc"  # VPC 이름
  cidr_block = var.vpc_cidr              # VPC의 CIDR 블록
}

#Subnet 생성 (퍼블릭 / 프라이빗)
module "subnet" {
  source              = "./modules/network/subnet"   # subnet 모듈 경로
  vpc_id              = module.vpc.vpc_id            # 연결할 VPC ID
  public_subnet_cidr  = var.public_subnet_cidr       # 퍼블릭 서브넷 CIDR
  private_subnet_cidr = var.private_subnet_cidr      # 프라이빗 서브넷 CIDR
  az                  = var.az                       # 가용 영역 (AZ)
  name_prefix         = var.name_prefix              # 이름 접두어
}

#인터넷 게이트웨이 생성
module "igw" {
  source = "./modules/network/internet-gateway"      # igw 모듈 경로
  vpc_id = module.vpc.vpc_id                         # 연결할 VPC ID
  name   = "${var.name_prefix}-igw"                  # IGW 이름
  tags   = var.tags                                  # 공통 태그
}

#NAT 게이트웨이 생성 (퍼블릭 서브넷에 설치)
module "nat_gateway" {
  source    = "./modules/network/nat-gateway"        # NAT 게이트웨이 모듈 경로
  name      = "${var.name_prefix}-nat"               # NAT 게이트웨이 이름
  subnet_id = module.subnet.public_subnet_id         # 퍼블릭 서브넷 ID
  tags      = var.tags                               # 공통 태그
}

#라우팅 테이블 구성 (퍼블릭/프라이빗 라우팅)
module "route_table" {
  source = "./modules/network/route-table"           # route-table 모듈 경로
  vpc_id = module.vpc.vpc_id

  route_tables = [
    {
      name       = "${var.name_prefix}-public-rt"    # 퍼블릭 RT 이름
      subnet_ids = [module.subnet.public_subnet_id]  # 퍼블릭 서브넷 연결
      routes = [
        {
          cidr_block     = "0.0.0.0/0"                       # 모든 트래픽 대상
          gateway_id     = module.igw.igw_id                 # IGW를 통해 인터넷 접근
          nat_gateway_id = null                              # NAT 사용하지 않음
        }
      ]
      tags = {}
    },
    {
      name       = "${var.name_prefix}-private-rt"   # 프라이빗 RT 이름
      subnet_ids = [module.subnet.private_subnet_id] # 프라이빗 서브넷 연결
      routes = [
        {
          cidr_block     = "0.0.0.0/0"
          gateway_id     = null
          nat_gateway_id = module.nat_gateway.nat_gateway_id  # NAT 게이트웨이 통해 외부 접근
        }
      ]
      tags = {}
    }
  ]
}

}