resource "aws_iam_role" "iam_for_lambda" {
  name = "aws_health_lambda_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "lambda_role" {
  name        = "aws_health_lambda_policy"
  path        = "/"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:us-east-2:${local.account_id}:log-group:/aws/lambda/aws_health:*"
    },
    {
      "Sid": "VisualEditor1",
      "Effect": "Allow",
      "Action": [
        "sns:Publish",
        "logs:CreateLogGroup"
      ],
      "Resource": [
        "arn:aws:logs:us-east-2:${local.account_id}:*",
        "arn:aws:sns:us-east-2:${local.account_id}:*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_role.arn
}


resource "aws_lambda_function" "aws_health_lambda" {
  filename      = "lambda_function.zip"
  function_name = "aws_health"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "aws_health.lambda_handler"
  timeout       = 30

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256("lambda_function.zip")

  runtime = "python3.9"
}