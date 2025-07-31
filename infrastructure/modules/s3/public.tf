# resource "aws_s3_bucket" "matchfit_bucket" {
#   bucket = "matchfit-bucket"

#   # 퍼블릭 엑세스 차단 해제 (중요)
#   block_public_acls = false
#   block_public_policy = false
#   ignore_public_acls = false
#   restrict_public_buckets = false
# }

# resource "aws_s3_bucket_policy" "public_read_sports_posts" {
#   bucket = aws_s3_bucket.matchfit_bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid = "PublicReadSportsPosts"
#         Effect = "Allow"
#         Principal = "*"
#         Action = "s3:GetObject"
#         Resource = "arn:aws:s3:::matchfit-bucket/sports-posts/*"
#       }
#     ]
#   })
# }