# MatchFit VPC 모듈 main.tf

# VPC 생성
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr                          # VPC의 IP 범위 (예: 10.0.0.0/16)
  enable_dns_support   = true                                  # 인스턴스의 내부 DNS 해석 활성화
  enable_dns_hostnames = true                                  # 퍼블릭 DNS 호스트네임 부여 활성화

  tags = {
    Name = "${var.name_prefix}-vpc"                            # VPC 리소스에 이름 태그 지정
  }
}

# Public Subnet 생성
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidr)
  vpc_id                  = aws_vpc.this.id                     # 연결할 VPC 지정
  cidr_block              = var.public_subnet_cidr[count.index] # 퍼블릭 서브넷 CIDR (예: 10.0.1.0/24)
  map_public_ip_on_launch = true                                # 인스턴스 시작 시 자동 퍼블릭 IP 할당
  availability_zone       = var.az[count.index]                 # 배치할 가용 영역 (예: ap-northeast-2a)

  tags = {
    Name = "${var.name_prefix}-public-${count.index + 1}"
  }
}

# Private Subnet 생성
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr)
  vpc_id            = aws_vpc.this.id                          # 연결할 VPC 지정
  cidr_block        = var.private_subnet_cidr[count.index]     # 프라이빗 서브넷 CIDR (예: 10.0.2.0/24)
  availability_zone = var.az[count.index]                      # 배치할 가용 영역

  tags = {
    Name = "${var.name_prefix}-private-${count.index + 1}"
  }
}

# Internet Gateway 생성
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id
  tags   = var.tags
}

# 퍼블릭 서브넷용 라우팅 테이블 생성
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id                                     # 연결할 VPC 지정

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

# 퍼블릭 라우팅 테이블에 인터넷 경로 추가
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id           # 연결할 라우팅 테이블
  destination_cidr_block = "0.0.0.0/0"                          # 전체 트래픽을 대상으로 함
  gateway_id             = aws_internet_gateway.this.id        # 외부로 나갈 IGW 지정
}

# 퍼블릭 서브넷과 라우팅 테이블 연결
resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id           # 연결할 퍼블릭 서브넷
  route_table_id = aws_route_table.public.id                   # 퍼블릭 라우팅 테이블
}

# 다중 라우팅 테이블 생성 (예: 퍼블릭/프라이빗/NAT 구성용)
resource "aws_route_table" "this" {
  count  = length(var.route_tables)                             # route_tables 리스트 길이만큼 반복 생성
  vpc_id = var.vpc_id                                           # 연결할 VPC ID

  dynamic "route" {
    for_each = var.route_tables[count.index].routes             # 각각의 라우팅 테이블에 들어갈 route 정보
    content {
      cidr_block     = route.value.cidr_block                   # 목적지 IP 범위 (CIDR)
      gateway_id     = route.value.gateway_id                   # 인터넷 게이트웨이 ID (선택적)
      nat_gateway_id = route.value.nat_gateway_id               # NAT 게이트웨이 ID (선택적)
    }
  }

  tags = merge(
    {
      Name = var.route_tables[count.index].name                 # 각 라우팅 테이블의 이름
    },
    var.route_tables[count.index].tags                          # 사용자 정의 태그
  )
}

# 라우팅 테이블과 서브넷 연결 (여러 개 자동 처리)
resource "aws_route_table_association" "this" {
  # count = sum([for rt in var.route_tables : length(rt.subnet_ids)])  # 모든 route_table의 subnet 개수를 합쳐서 반복 횟수 결정
  count = length(var.route_tables) > 0 ? sum([for rt in var.route_tables : length(rt.subnet_ids)]) : 0

  subnet_id      = local.subnet_route_associations[count.index].subnet_id      # 연결할 서브넷
  route_table_id = local.subnet_route_associations[count.index].route_table_id # 연결할 라우팅 테이블
}

# 라우팅 테이블-서브넷 매핑을 위한 로컬 변수 정의
locals {
  subnet_route_associations = flatten([                             # 리스트를 평탄화하여 단일 리스트로 변환
    for rt_idx, rt in var.route_tables : [                          # 각 라우팅 테이블에 대해
      for subnet_id in rt.subnet_ids : {                            # 연결할 모든 서브넷에 대해
        subnet_id      = subnet_id                                  # 해당 서브넷 ID
        route_table_id = aws_route_table.this[rt_idx].id            # 해당 라우팅 테이블 ID
      }
    ]
  ])
}