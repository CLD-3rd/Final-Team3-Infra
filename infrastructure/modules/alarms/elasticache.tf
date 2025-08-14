# Redis CPU 사용률 알람 분석
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.name_prefix}-redis-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Redis CPU usage > 80%"
  dimensions = {
    CacheClusterId = var.redis_replica_group_id
  }
  alarm_actions = [var.sns_topic_arn]
}

# Redis 복제 지연 알람 분석
resource "aws_cloudwatch_metric_alarm" "replication_lag" {
  alarm_name          = "${var.name_prefix}-redis-replication-lag"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "ReplicationLag"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Maximum"
  threshold           = 2
  alarm_description   = "Redis replication lag over 2 seconds"
  dimensions = {
    CacheClusterId = var.redis_replica_group_id
  }
  alarm_actions = [var.sns_topic_arn]
}

# Redis 메모리 부족 분석 및 강제 캐시 삭제 발생 현황
resource "aws_cloudwatch_metric_alarm" "redis_evictions_alarm" {
  alarm_name          = "${var.name_prefix}-redis-evictions-alarm"
  alarm_description   = "Alarm when Redis Evictions exceed threshold"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "Evictions"
  namespace           = "AWS/ElastiCache"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_topic_arn]
  dimensions = {
    CacheClusterId = var.redis_replica_group_id
  }
  treat_missing_data = "notBreaching"
  tags               = var.tags
}