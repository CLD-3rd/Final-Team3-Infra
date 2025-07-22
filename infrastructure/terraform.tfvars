aws_region          = "ap-northeast-2"              # 서울 리전
name_prefix         = "matchfit"                    # 접두어
vpc_cidr            = "10.0.0.0/16"                 # VPC IP 범위

# 퍼블릭 서브넷 IP
public_subnet_cidr  = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]

# 프라이빗 서브넷 IP
private_subnet_cidr = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

# 사용할 가용 영역
az                  = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]

cluster_name        = "team3-eks"
kubernetes_version  = "1.27"
service_ipv4_cidr   = "172.20.0.0/16"
ssh_key_name        = "final3-key"
#worker_access_cidr  = ["10.0.2.0/24"]

route_tables = []

