output "cluster_name" {
  value = aws_eks_cluster.this.name
}
output "cluster_resource" {
  value = aws_eks_cluster.this
}
output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}
output "cluster_certificate_authority" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
output "cluster_id" {
  value = aws_eks_cluster.this.id
}
output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}
output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}
output "eks_node_instance_profile" {
  value = aws_iam_instance_profile.eks_node_instance_profile[0].name
}
output "cluster_sg_id" {
  value = aws_security_group.eks_cluster_sg.id
}
output "node_group_name" {
  value = aws_eks_node_group.default.node_group_name
}
output "eks_node_sg_id" {
  value = aws_security_group.eks_node_sg.id
}


output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.this.arn
}

output "cluster_oidc_issuer_url" {
  value = aws_eks_cluster.this.identity[0].oidc[0].issuer
}