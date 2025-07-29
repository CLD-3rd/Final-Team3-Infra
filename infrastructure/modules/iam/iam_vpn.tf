# Cloudwatch logging 관련 IAM 역할 생성

resource "aws_iam_role" "vpn_logging_role" {
  name = "${var.name_prefix}-vpn-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "clientvpn.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "vpn_logging_policy" {
  name = "${var.name_prefix}-vpn-logging-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      Resource = "*"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "vpn_logging_attach" {
  role       = aws_iam_role.vpn_logging_role.name
  policy_arn = aws_iam_policy.vpn_logging_policy.arn
}