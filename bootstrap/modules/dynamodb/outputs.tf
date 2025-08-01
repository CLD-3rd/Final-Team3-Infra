output "table_name" {
  description = "DynamoDB 테이블 이름"
  value = aws_dynamodb_table.this.name
}