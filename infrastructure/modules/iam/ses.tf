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

  name = "${var.name_prefix}-ses-smtp-policy"
  user = local.user_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail",
        "ses:GetSendQuota",
        "ses:GetSendStatistics",
        "ses:GetIdentityVerificationAttributes",
        "ses:VerifyDomainIdentity",
        "ses:VerifyEmailIdentity",
        "ses:ListIdentities",
        "ses:ListEmailIdentities",
        "ses:DeleteIdentity",
        "ses:GetIdentityPolicies",
        "ses:PutIdentityPolicy",
        "ses:DeleteIdentityPolicy",
        "ses:SetIdentityDkimEnabled",
        "ses:GetIdentityDkimAttributes",
        "ses:VerifyDomainDkim",
        "ses:ListVerifiedEmailAddresses",
        "ses:GetAccount",
        "ses:ListDomains",
        "ses:ListRecommendations",
        "ses:UpdateAccountSendingEnabled",
        "ses:PutAccountDedicatedIpWarmupAttributes",
        "ses:PutAccountSendingAttributes",
        "ses:GetEmailIdentity",
        "ses:CreateEmailIdentity",
        "ses:DeleteEmailIdentity",
        "ses:UpdateEmailIdentityPolicy",
        "ses:ListConfigurationSets",
        "ses:CreateConfigurationSet",
        "ses:DeleteConfigurationSet",
        "ses:UpdateConfigurationSetEventDestination",
        "ses:SendBulkTemplatedEmail",
        "ses:SendTemplatedEmail",
        "ses:CreateReceiptRuleSet",
        "ses:DeleteReceiptRuleSet",
        "ses:SetReceiptRuleSet",
        "ses:CreateReceiptRule",
        "ses:DeleteReceiptRule",
        "ses:UpdateReceiptRule",
        "ses:DescribeReceiptRule",
        "ses:DescribeReceiptRuleSet",
        "ses:PutAccountDetails"
      ]
      Resource = "*"
    }]
  })
}

# 기존 Access Key 그대로 사용