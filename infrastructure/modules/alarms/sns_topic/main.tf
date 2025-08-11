resource "aws_sns_topic" "this" {
  name_prefix = "${var.name_prefix}-alert-topic"

  tags = var.tags
}

resource "aws_sns_topic_subscription" "email" {
  count = length(var.subscriptions)

  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = var.subscriptions[count.index]
}
