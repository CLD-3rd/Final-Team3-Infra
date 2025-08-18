# NAT 데이터 처리량 초과 알람
resource "aws_cloudwatch_metric_alarm" "nat_high_data_processed" {
  alarm_name          = "${var.name_prefix}-nat-high-data"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BytesOutToDestination"
  namespace           = "AWS/NATGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 1073741824  # 1GB in 5분 단위

  alarm_description = "NAT Gateway outbound traffic > 10GB in 5 minutes"

  dimensions = {
    NatGatewayId = var.nat_gateway_id
  }

  alarm_actions = [var.sns_topic_arn]
}

# NAT 연결 수 (ActiveConnectionCount) 알람
resource "aws_cloudwatch_metric_alarm" "nat_high_connections" {
  alarm_name          = "${var.name_prefix}-nat-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ActiveConnectionCount"
  namespace           = "AWS/NATGateway"
  period              = 300
  statistic           = "Average"
  threshold           = 50  # 예시 기준, 상황에 맞게 조정
  alarm_description   = "NAT Gateway active connections exceed 1000"

  dimensions = {
    NatGatewayId = var.nat_gateway_id
  }

  alarm_actions = [var.sns_topic_arn]
}