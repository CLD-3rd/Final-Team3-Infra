output "cloudformation_stack_name" {
  value = aws_cloudformation_stack.karpenter.name
}

output "karpenter_node_role_name" {
  # CFN creates a role named KarpenterNodeRole-<cluster> by convention
  value = "KarpenterNodeRole-${var.cluster_name}"
}

output "karpenter_node_role_arn" {
  value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/KarpenterNodeRole-${var.cluster_name}"
}

output "karpenter_controller_policy_arn" {
  value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/KarpenterControllerPolicy-${var.cluster_name}"
}
