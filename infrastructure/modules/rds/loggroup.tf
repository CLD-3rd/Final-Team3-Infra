# 로그 그룹 생성
# resource "aws_cloudwatch_log_group" "rds_general_log" {
#   name              = "/aws/rds/instance/${aws_db_instance.this.identifier}/general"
#   retention_in_days = 30
# }

# 이미 존재하는 로그 그룹과 매핑
data "aws_cloudwatch_log_group" "rds_general_log" {
  count = var.log_group_exists ? 0 : 1
  name = "/aws/rds/instance/${aws_db_instance.this.identifier}/general"
}



resource "aws_db_parameter_group" "mysql_param_group" {
  name   = "rds-mysql-log-group-250811"
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
