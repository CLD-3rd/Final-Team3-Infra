resource "aws_s3_bucket" "nlb_log_bucket" {
  bucket        = var.nlb_log_bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "nlb_log_lifecycle" {
  bucket = aws_s3_bucket.nlb_log_bucket.id

  rule {
    id     = "expire-nlb-logs"
    status = "Enabled"
    filter {}
    expiration {
      days = 30
    }
  }
}
