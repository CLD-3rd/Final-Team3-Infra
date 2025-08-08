# 로그 그룹 생성
resource "aws_cloudwatch_log_group" "rds_general_log" {
  name              = "/aws/rds/instance/${aws_db_instance.this.identifier}/general"
  retention_in_days = 30
}

resource "aws_db_parameter_group" "rds_logs" {
  name   = "rds-mysql-log-group"
  family = "mysql8.0"

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  parameter {
    name  = "general_log"
    value = "1"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "log_queries_not_using_indexes"
    value = "1"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }
}
