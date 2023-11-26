locals {
  variables   = var.environment_variables != {} ? var.environment_variables : null
  enabled_vpc = var.enabled_vpc ? [""] : []
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/lambda/${var.name}"
}

data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    resources = ["*"]
  }

  depends_on = [
    aws_cloudwatch_log_group.this
  ]
}

resource "aws_iam_policy" "this" {
  name        = "${var.name}-lambda-execution-policy"
  description = var.policy_description
  policy      = data.aws_iam_policy_document.policy.json
  path        = "/service-role/"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "this" {
  name               = "terraform-${var.name}-lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  path               = "/service-role/"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn

  depends_on = [
    aws_iam_role.this,
    aws_iam_policy.this
  ]
}

resource "aws_lambda_function" "this" {
  function_name = var.name
  description   = var.description
  filename      = var.filename
  role          = aws_iam_role.this.arn
  handler       = var.hadler
  runtime       = "ruby3.2"
  architectures = [
    var.architecture
  ]

  dynamic "vpc_config" {
    for_each = toset(local.enabled_vpc)
    content {
      subnet_ids         = var.vpc_config_values.subnet_ids
      security_group_ids = var.vpc_config_values.security_group_ids
    }
  }

  environment {
    variables = local.variables
  }

  depends_on = [
    aws_iam_role_policy_attachment.this
  ]
}
