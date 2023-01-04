data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "custominsights" {
  name   = "SecurityHubInsights"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        },
        {
            "Action": [
                "securityhub:CreateInsight"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "custominsights" {
  name       = "SecurityHubInsights"
  roles      = [aws_iam_role.insights_lambda.name]
  policy_arn = aws_iam_policy.custominsights.arn
}

resource "aws_iam_role" "custominsights" {
  name               = "SecurityHubInsights"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

resource "aws_iam_policy" "sechub_summariser" {
  name   = "SecurityHubSendEmailToSNS"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "SID":  "AllowSNS"
            "Action": "sns:Publish",
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "SID":  "AllowSecurityhub"
            "Effect": "Allow",
            "Action": [
                "securityhub:Get*",
                "securityhub:List*",
                "securityhub:Describe*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy_attachment" "sechub_summariser" {
  name       = "SecurityHubSendEmailToSNS"
  roles      = [aws_iam_role.sechub_summariser.name]
  policy_arn = aws_iam_policy.sechub_summariser.arn
}

resource "aws_iam_role_policy_attachment" "sechub_summariser" {
  role       = aws_iam_role.sechub_summariser.name
  policy_arn = "arn:aws:iam::aws:policy/AWSSecurityHubReadOnlyAccess"
}

resource "aws_iam_role" "sechub_summariser" {
  name               = "SecurityHubSendEmailToSNS"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}
