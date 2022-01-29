resource "aws_sns_topic" "aws_health_sns" {
  name = "aws_health"
}

resource "aws_sns_topic_subscription" "sns_cullan" {
  topic_arn = aws_sns_topic.aws_health_sns.arn
  protocol  = "email"
  endpoint  = "cullancarey@yahoo.com"
}