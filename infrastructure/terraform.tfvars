aws_region          = "ap-northeast-2"
name_prefix         = "team3"

vpc_cidr            = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
az                  = "ap-northeast-2a"

cluster_name        = "team3-eks"
kubernetes_version  = "1.27"
service_ipv4_cidr   = "172.20.0.0/16"
ssh_key_name        = "final3-key"
#worker_access_cidr  = ["10.0.2.0/24"]

route_tables = []

