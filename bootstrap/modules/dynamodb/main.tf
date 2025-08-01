resource "aws_dynamodb_table" "this" {
  name         = var.table_name
  billing_mode = "PAY_PER_REQUEST"  # 요청 당 비용 지불
  hash_key     = "LockID"           # 잠금을 식별할 고유 키(누가 잠금 중인지 기록)

  attribute {                       # 테이블 키 정의
    name = "LockID"                 # 위의 hash key와 일치
    type = "S"                      # 문자열로 지정
  }

  tags = var.tags
}