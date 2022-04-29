/*
Lambda
*/
resource "aws_iam_role" "sketchy_router_webui" {
  name               = "sketchy-router-webui"
  assume_role_policy = file("iam-trust-policy-lambda.json")
}

# resource "aws_iam_role_policy_attachment" "attachment_assume_role_lambda" {
#   #  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
#   role = aws_iam_role.sketchy_router_webui.name
# }

/*
Logging
*/
resource "aws_iam_role" "role_sketchy_router_logging" {
  name               = "sketchy-router-logging"
  assume_role_policy = file("iam-trust-policy-logging.json")
}

resource "aws_iam_policy" "policy_api_logging" {
  name        = "test-policy2"
  description = "A test policy"
  policy      = file("iam-policy-logging.json")
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "attachment-logging-role"
  roles      = [aws_iam_role.role_sketchy_router_logging.name, aws_iam_role.sketchy_router_webui.name]
  policy_arn = aws_iam_policy.policy_api_logging.arn
}
