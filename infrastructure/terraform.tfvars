aws_region          = "ap-northeast-2"              # 서울 리전
name_prefix         = "matchfit"                    # 접두어
vpc_cidr            = "100.0.0.0/16"                 # VPC IP 범위

# 퍼블릭 서브넷 IP
public_subnet_cidr  = ["100.0.10.0/24", "100.0.20.0/24", "100.0.30.0/24"]

# 프라이빗 서브넷 IP
private_subnet_cidr = ["100.0.1.0/24", "100.0.2.0/24", "100.0.3.0/24"]

# 사용할 가용 영역
az                  = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]

cluster_name        = "matchfit-eks"
kubernetes_version  = "1.33"
service_ipv4_cidr   = "172.20.0.0/16"
ssh_key_name        = "matchfit-eks-key"
#worker_access_cidr  = ["10.0.2.0/24"]

route_tables = []

# 공통 태그
default_tags = {
  Project = "team3"
  Environment = "dev"
}

# admin role
admin_user_arn = "arn:aws:iam::061039804626:user/lion3fteam03"

# RDS DB 기본 설정
db_name     = "matchfit_db"
db_username = "admin"
db_password = "matchfit!123fit"  # 실제 운영 시엔 tfvars 파일을 git에 커밋하지 말고, Secret Manager 사용 권장
# Subnet Group 생성 여부
create_subnet_group = true
db_subnet_group_name = null  # 외부에서 주입 시: "my-custom-subnet-group"
# 고가용성 구성
multi_az = true  # or false
# 백업 및 유지보수 설정
backup_retention_period = 7
snapshot_window           = "11:30-13:00"
maintenance_window      = "sun:00:00-sun:02:00"
# 삭제 보호 및 최종 스냅샷 옵션
skip_final_snapshot = true
deletion_protection = false

# S3
bucket_name = "matchfit-bucket"

# Redis 접속 비밀번호(16자리 이상)
auth_token = "matchfit250822redis"

server_certificate_arn="arn:aws:acm:ap-northeast-2:061039804626:certificate/8b1167e0-2d9c-458e-a109-101781388822"
client_ca_certificate_arn="arn:aws:acm:ap-northeast-2:061039804626:certificate/29ad88cc-1c1b-446d-bdb5-ee356de27ab8"