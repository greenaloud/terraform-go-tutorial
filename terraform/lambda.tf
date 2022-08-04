resource "aws_iam_role" "wocho-test" {
  name = "LambdaRole_WochoTest" # 고유한 이름이어야 한다.

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {"Service": "lambda.amazonaws.com"},
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "wocho-test" {
  role       = aws_iam_role.wocho-test.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "wocho-test" {
  function_name = "wocho-test"
  role          = aws_iam_role.wocho-test.arn
  filename      = "../lambda.zip" # 우선 로컬에 있는 파일을 직접 업로드한다.
  handler       = "main"
  runtime       = "go1.x"
  memory_size   = 1024
  timeout       = 300

  environment {
    variables = {
      APP_ENV = "production"
    }
  }
}

resource "aws_lambda_permission" "wocho-test" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.wocho-test.arn
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:ap-northeast-2:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.wocho-test.id}/*/*"
}

resource "aws_iam_policy" "wocho-test-dynamodb" {
  name = "LambdaPolicy_WochoTest"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:PutItem",
        "dynamodb:DeleteItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:ListTable",
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:DescribeLimits",
        "dynamodb:GetRecords"
      ],
      "Resource": "arn:aws:dynamodb:ap-northeast-2:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.wocho-test.name}"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "wocho-test-dynamodb" {
  role       = aws_iam_role.wocho-test.name
  policy_arn = aws_iam_policy.wocho-test-dynamodb.arn
}

resource "aws_cloudwatch_log_group" "wocho-test" {
  name = "/aws/lambda/wocho-test"
}