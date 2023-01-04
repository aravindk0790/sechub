data "archive_file" "insights_code" {
  type        = "zip"
  source_file = "${path.module}/index.js"
  output_path = "${path.module}/index.js.zip"
}

data "archive_file" "mail_code" {
  type        = "zip"
  source_file = "${path.module}/index.py"
  output_path = "${path.module}/sec-hub-email.zip"
}

resource "aws_lambda_function" "custominsights" {
  filename         = data.archive_file.code.output_path
  function_name    = var.custominsights_lambda_name
  role             = aws_iam_role.custominsights.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.insights_code.output_base64sha256
  runtime          = "nodejs16.x"
  timeout          = 30
}

resource "aws_lambda_function" "sechub_summariser" {
  filename         = data.archive_file.code.output_path
  function_name    = var.sechub_lambda_name
  role             = aws_iam_role.sechub_summariser.arn
  handler          = "index.lambda_handler"
  source_code_hash = data.archive_file.mail_code.output_base64sha256
  runtime          = "python3.7"
  timeout          = 30

  environment {
    variables = {
      ARNInsight01              = aws_lambda_function.custominsights.arn
      ARNInsight02              = aws_lambda_function.custominsights.arn
      ARNInsight03              = aws_lambda_function.custominsights.arn
      ARNInsight04              = aws_lambda_function.custominsights.arn
      ARNInsight05              = aws_lambda_function.custominsights.arn
      ARNInsight06              = aws_lambda_function.custominsights.arn
      ARNInsight07              = aws_lambda_function.custominsights.arn
      SNSTopic                  = aws_sns_topic.topic.arn
      AdditionalEmailFooterText = var.additional_email_footer_text
    }
  }
}