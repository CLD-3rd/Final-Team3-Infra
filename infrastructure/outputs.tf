# VPC ID 출력
output "vpc_id" {
  description = "모듈에서 생성한 VPC ID"
  value       = module.network.vpc_id
}

# 퍼블릭 서브넷 ID 출력
output "public_subnet_id" {
  description = "모듈에서 생성한 퍼블릭 서브넷 ID"
  value       = module.network.public_subnet_id
}

# 프라이빗 서브넷 ID 출력
output "private_subnet_id" {
  description = "모듈에서 생성한 프라이빗 서브넷 ID"
  value       = module.network.private_subnet_id
}

# IGW ID 출력
output "igw_id" {
  description = "모듈에서 생성한 인터넷 게이트웨이 ID"
  value       = module.network.igw_id
}

# 커스텀 라우팅 테이블 ID 리스트 출력
output "custom_route_table_ids" {
  description = "모듈에서 생성한 사용자 정의 라우팅 테이블 ID 목록"
  value       = module.network.custom_route_table_ids
}