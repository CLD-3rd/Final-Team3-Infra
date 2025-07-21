# VPC ID 출력
output "vpc_id" {
  description = "생성된 VPC ID"
  value       = module.vpc.vpc_id
}

# 퍼블릭 서브넷 ID 출력
output "public_subnet_id" {
  description = "생성된 퍼블릭 서브넷 ID"
  value       = module.subnet.public_subnet_id
}

# 프라이빗 서브넷 ID 출력
output "private_subnet_id" {
  description = "생성된 프라이빗 서브넷 ID"
  value       = module.subnet.private_subnet_id
}

# IGW ID 출력
output "igw_id" {
  description = "생성된 인터넷 게이트웨이 ID"
  value       = module.igw.igw_id
}

# NAT 게이트웨이 ID 출력
output "nat_gateway_id" {
  description = "생성된 NAT 게이트웨이 ID"
  value       = module.nat_gateway.nat_gateway_id
}

# 모든 라우팅 테이블 ID 리스트 출력
output "custom_route_table_ids" {
  description = "생성된 라우팅 테이블 ID 목록"
  value       = module.route_table.route_table_ids
}
