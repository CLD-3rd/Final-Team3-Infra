# sns topic 관련 생성
# resource "aws_sns_topic" "this" {
#   name_prefix = "${var.name_prefix}-alert-topic"
#   tags = var.tags
# }

# 이미 있는 데이터 값 참조
data "aws_sns_topic" "this" {
  name = "${var.name_prefix}-alert-topic"
}

resource "aws_sns_topic_subscription" "email" {
  count = length(var.subscriptions)

  topic_arn = data.aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.subscriptions[count.index]
}
