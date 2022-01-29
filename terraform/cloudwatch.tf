resource "aws_cloudwatch_event_rule" "aws_health_rule" {
  name        = "aws_health_check"
  schedule_expression = "rate(2 hours)"
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.aws_health_rule.name
  target_id = "SendToSNS"
  arn       = aws_lambda_function.aws_health_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.aws_health_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.aws_health_rule.arn
}