variable "karpenter_controller_role_arn" { type = string }

variable "karpenter_node_role_arn" { type = string }

variable "cluster_name" { type = string }

variable "manage_aws_auth_with_terraform" {
    type = bool
    default = true
}