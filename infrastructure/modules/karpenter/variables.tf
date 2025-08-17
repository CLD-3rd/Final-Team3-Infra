variable "cluster_name" { type = string }
variable "region" { type = string }
variable "subnet_ids" { type = list(string) }
variable "node_sg_id" { type = string }
variable "oidc_provider_arn" { type = string }        # module.eks 의 oidc_provider_arn
variable "oidc_issuer_url" { type = string }         # module.eks 의 cluster_oidc_issuer_url
