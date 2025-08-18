resource "aws_iam_policy" "grafana_athena_policy" {
  name        = "${var.name_prefix}-grafana-athena-policy"
  description = "Athena + Glue read permissions for Grafana"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "athena:GetWorkGroup",
          "athena:StartQueryExecution",
          "athena:GetQueryResults",
          "athena:GetQueryExecution",
          "athena:ListWorkGroups"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables"
        ],
        Resource = [
          "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:catalog",
          "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:database/*",
          "arn:aws:glue:${var.region}:${data.aws_caller_identity.current.account_id}:table/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ],
        Resource = [
          # S3 버킷 생성 시에 사용하는 구문
          # "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}/athena-query-results/*",
          # "arn:aws:s3:::${aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/*"
          # 존재하는 S3 버킷 참조 시에 사용하는 구문
          "arn:aws:s3:::${data.aws_s3_bucket.cloudfront_log_bucket.bucket}",
          "arn:aws:s3:::${data.aws_s3_bucket.cloudfront_log_bucket.bucket}/athena-query-results/*",
          "arn:aws:s3:::${data.aws_s3_bucket.cloudfront_log_bucket.bucket}/cloudfront-logs/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_athena_policy" {
  role       = var.grafana_irsa_role_name  # 기존 IRSA 역할 이름
  policy_arn = aws_iam_policy.grafana_athena_policy.arn
}
