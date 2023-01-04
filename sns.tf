resource "aws_sns_topic" "topic" {
  name              = var.name
  kms_master_key_id = var.kms_key_id
  tags              = var.tags
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "email"
  endpoint  = var.email
}