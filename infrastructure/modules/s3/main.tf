# S3 버킷 생성 
resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name              # 사용자 정의 버킷 이름 (전역 고유)
  tags   = var.tags                     # 리소스에 공통 태그 적용
}

# 버킷 버전 관리 설정 - 객체 이력 보존 기능
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Disabled"  # true이면 버전 관리 활성화
  }
}

# 정적 웹 호스팅 구성 - 웹 서버 없이 HTML 콘텐츠 제공
resource "aws_s3_bucket_website_configuration" "this" {
  count  = var.enable_website ? 1 : 0   # 웹사이트 활성화 여부에 따라 생성 여부 결정
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = var.index_document         # 기본 페이지 (예: index.html)
  }

  error_document {
    key = var.error_document            # 오류 발생 시 표시할 문서
  }
}

# 퍼블릭 접근 차단 설정 - 보안 강화를 위한 필수 설정
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = var.block_public_acls       # 퍼블릭 ACL 차단 여부
  block_public_policy     = var.block_public_policy     # 퍼블릭 정책 차단 여부
  ignore_public_acls      = var.ignore_public_acls      # 퍼블릭 ACL 무시 여부
  restrict_public_buckets = var.restrict_public_buckets # 퍼블릭 버킷 제한 여부
}

# S3 버킷 정책 - 외부에서 주입된 JSON 정책을 적용 (선택적 리소스)
resource "aws_s3_bucket_policy" "this" {
  count  = var.bucket_policy != null ? 1 : 0             # 정책이 있을 경우만 생성
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(var.bucket_policy)                # JSON 오브젝트 문자열로 변환

  depends_on = [aws_s3_bucket_public_access_block.this] # 보안 정책 적용 후 실행
}

