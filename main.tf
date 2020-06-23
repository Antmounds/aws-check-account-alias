# Configure remote state
terraform {
  required_version = ">=0.12.26"

  backend "s3" {
    bucket  = "antmounds"
    key     = "terraform-state/check-account-alias.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

resource "aws_lambda_function" "check_alias_lambda" {
  function_name = var.app_name
  description   = "checks IAM every 5 mins for availability of a specific account alias"
  filename      = "lambda_function_payload.zip"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_role.arn

  source_code_hash = filebase64sha256("lambda_function_payload.zip")

  memory_size = 128
  timeout     = 3
  runtime     = "ruby2.7"

  environment {
    variables = {
      GOAL_ACCOUNT_ALIAS = var.goal_account_alias
      SNS_TOPIC_ARN      = aws_sns_topic.check_iam_account.arn
      App                = var.app_name
      Environment        = "PROD"
      Organization       = "Antmounds"
      Team               = "DevOps"
      Owner              = var.owner
    }
  }

  tags = {
    Name         = "check-account-alias-tf"
    Description  = "checks IAM every 5 mins for availability of a specific account alias"
    Organization = "Antmounds"
    Department   = "Engineering"
    Team         = "DevOps"
    Owner        = var.owner
    Provisioner  = "Terraform"
    App          = var.app_name
  }

}

resource "aws_iam_role" "lambda_role" {
  name = "${var.app_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    Name         = "check-account-alias-tf"
    Description  = "role for lambda to check IAM every 5 mins for availability of a specific account alias"
    Organization = "Antmounds"
    Department   = "Engineering"
    Team         = "DevOps"
    Owner        = var.owner
    Provisioner  = "Terraform"
    App          = var.app_name
  }
}

resource "aws_iam_role_policy" "lambda_policy" {
  name = "${var.app_name}-policy"
  role = aws_iam_role.lambda_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:CreateAccountAlias",
        "iam:ListAccountAliases",
        "lambda:PutFunctionConcurrency",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "sns:Publish"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_sns_topic" "check_iam_account" {
  name         = "check-account-alias-tf"
  display_name = "check-account-alias-tf"

  tags = {
    Name         = "check-account-alias-tf"
    Description  = "sends a notification when the IAM account alias has been successfully changed"
    Organization = "Antmounds"
    Department   = "Engineering"
    Team         = "DevOps"
    Owner        = var.owner
    Provisioner  = "Terraform"
    App          = var.app_name
  }
}

resource "aws_sns_topic_subscription" "check_iam_account" {
  topic_arn = aws_sns_topic.check_iam_account.arn
  protocol  = "sms"
  endpoint  = var.notification_number
}

resource "aws_cloudwatch_event_rule" "check_account_alias_event_rule" {
  name                = "check-account-alias-every-5m"
  description         = "fires an event to lambda every 5 min to check for an account alias"
  schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "check_account_alias_event_target" {
  rule      = aws_cloudwatch_event_rule.check_account_alias_event_rule.name
  target_id = "CheckAccountAliasLambda"
  arn       = aws_lambda_function.check_alias_lambda.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.check_alias_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.check_account_alias_event_rule.arn
}