# MatchFit VPC 모듈 outputs.tf

# VPC ID 출력
output "vpc_id" {
  description = "생성된 VPC의 ID"
  value       = aws_vpc.this.id
}

# 퍼블릭 서브넷 ID 출력
output "public_subnet_id" {
  description = "생성된 퍼블릭 서브넷 ID"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

# 프라이빗 서브넷 ID 출력
output "private_subnet_id" {
  description = "생성된 프라이빗 서브넷 ID"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

# 퍼블릭 라우팅 테이블 ID 출력
output "public_route_table_id" {
  description = "생성된 퍼블릭 라우팅 테이블 ID"
  value       = aws_route_table.public.id
}

# IGW ID 출력
output "igw_id" {
  description = "생성된 인터넷 게이트웨이 ID"
  value       = aws_internet_gateway.this.id
}

# Nat Gateway 출력
output "nat_gateway_id" {
  value = aws_nat_gateway.this.id
}

# 다중 라우팅 테이블 ID 목록 출력
output "custom_route_table_ids" {
  description = "사용자 정의 라우팅 테이블 ID 목록 (count 기반)"
  value       = [for rt in aws_route_table.this : rt.id]
}