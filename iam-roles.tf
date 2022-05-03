/*
Control of EC2
*/
resource "aws_iam_role" "ec2_control" {
  name               = "sketchy-router-ec2"
  assume_role_policy = file("iam-trust-policy-apigateway.json")
}

resource "aws_iam_policy_attachment" "attachment_ec2_control" {
  name = "attachment_ec2_control_policy"
  policy_arn = aws_iam_policy.policy_ec2.arn
  roles = [aws_iam_role.ec2_control.name]
}

resource "aws_iam_policy" "policy_ec2" {
  name        = "ec2_control"
  policy      = file("iam-policy-ec2.json")
}

/*
API Gateway Logging
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
  roles      = [aws_iam_role.role_sketchy_router_logging.name]
  policy_arn = aws_iam_policy.policy_api_logging.arn
}
