resource "aws_lambda_permission" "trigger" {
  statement_id  = "AllowExecutionFromEvents"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sechub_summariser.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.trigger.arn
}

resource "aws_cloudwatch_event_rule" "trigger" {
  name                = "SecurityHubSummaryEmailSchedule"
  description         = "Triggers the Recurring Security Hub summary email"
  schedule_expression = var.schedule
}

resource "aws_cloudwatch_event_target" "lambda" {
  rule      = aws_cloudwatch_event_rule.trigger.name
  target_id = "TriggerLambda"
  arn       = aws_lambda_function.sechub_summariser.arn
}