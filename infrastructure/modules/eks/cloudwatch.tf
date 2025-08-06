#CloudWatch 로그 그룹 관련 리소스
# FluentBit CloudWatch LogGroup
resource "aws_cloudwatch_log_group" "fluentbit" {
  name              = "/aws/eks/${var.cluster_name}/application"
  retention_in_days = 30
  tags              = var.tags
}