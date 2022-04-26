/*
Lambda
*/
resource "aws_iam_role" "sketchy_router_webui" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_lambda.json
  name               = "sketchy-router-webui"
}

data "aws_iam_policy_document" "assume_role_lambda" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions   = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy_attachment" "attachment_assume_role_lambda" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sketchy_router_webui.name
}

/*
Logging
*/
resource "aws_iam_role" "sketchy_router_logging" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_logging.json
  name               = "sketchy-router-logging"
}

data "aws_iam_policy_document" "assume_role_logging" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["apigateway.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "attachment_assume_role_logs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.sketchy_router_logging.name
}

# resource "aws_iam_role_policy_attachment" "assume_role" {
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role       = aws_iam_role.sketchy_router_webui.name
# }

# resource "aws_iam_policy_attachment" "logs" {
#   name       = "Use Any Identifier/Name You Want Here For IAM Policy Logs"
#   policy_arn = aws_iam_policy.logs.arn
#   roles      = [aws_iam_role.lambda.name]
# }

# resource "aws_iam_policy" "logs" {
#   name   = "Use Any Identifier/Name You Want Here For IAM Policy Logs"
#   policy = data.aws_iam_policy_document.logs.json
# }
