data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "assume_role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

resource "aws_iam_role" "lambda" {
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
  name               = "sketchy-router-"
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

# resource "aws_iam_policy_attachment" "logs" {
#   name       = "Use Any Identifier/Name You Want Here For IAM Policy Logs"
#   policy_arn = aws_iam_policy.logs.arn
#   roles      = [aws_iam_role.lambda.name]
# }

# resource "aws_iam_policy" "logs" {
#   name   = "Use Any Identifier/Name You Want Here For IAM Policy Logs"
#   policy = data.aws_iam_policy_document.logs.json
# }

output "role_arn" {
  value       = aws_iam_role.lambda.arn
  description = "ARN of Lambda role"
}