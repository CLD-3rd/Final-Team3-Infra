variable "table_name" {
  description = "DynamoDB 테이블 이름"
  type = string
}

variable "tags" {
  description = "리소스에 붙일 태그"
  type        = map(string)
}