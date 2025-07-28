variable "name_prefix" {
  type        = string
  description = "리소스 이름 접두사"
}

variable "force_delete" {
  description = "리포지토리에 이미지가 있어도 삭제 가능 여부"
  type        = bool
}

variable "scan_on_push" {
  description = "이미지 푸시 시 자동 취약점 스캔 여부"
  type        = bool
}

variable "tags" {
  description = "ECR 리포지토리에 설정할 태그 목록"
  type        = map(string)
}

variable "image_tag_mutability" {
  description = "이미지 태그 변경 가능 여부 (MUTABLE 또는 IMMUTABLE)"
  type        = string
}

variable "encryption_type" {
  description = "암호화 방식 (AES256 또는 KMS)"
  type        = string
}