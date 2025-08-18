locals {
  # arn에서 "user/username" 부분만 뽑기
  # "arn:aws:iam::123456789012:user/username" -> "user/username"
  user_path = regex("(user/.+)$", data.aws_caller_identity.current.arn)
  
  # "user/username" 에서 username만 추출
  user_name = length(local.user_path) > 0 ? split("/", local.user_path[0])[1] : null
}

# IAM 사용자 이름이 있으면 정책 붙이기 (현재 인증된 주체가 IAM 사용자일 때만)
resource "aws_iam_user_policy" "ses_smtp_user_policy" {
  count = local.user_name != null ? 1 : 0

  name = "${local.user_name}-ses-smtp-policy"
  user = local.user_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ses:SendRawEmail"
      ]
      Resource = "*"
    }]
  })
}

# 기존 Access Key 그대로 사용