/*
Control of EC2
*/
resource "aws_iam_role" "ec2_control_role" {
  name               = "sketchy-router-ec2"
  assume_role_policy = file("iam-trust-policy-apigateway.json")
}

resource "aws_iam_policy" "ec2_control_policy" {
  name        = "sketch-router-ec2"
  policy      = file("iam-policy-ec2.json")
}

resource "aws_iam_policy_attachment" "ec2_control_attachment" {
  name = "ec2_control_attachment"
  roles = [aws_iam_role.ec2_control_role.name]
  policy_arn = aws_iam_policy.ec2_control_policy.arn
}

/*
API Gateway Logging
*/
resource "aws_iam_role" "logging_role" {
  name               = "sketchy-router-logging"
  assume_role_policy = file("iam-trust-policy-logging.json")
}

resource "aws_iam_policy" "logging_policy" {
  name        = "sketchy-router-logging"
  policy      = file("iam-policy-logging.json")
}

resource "aws_iam_policy_attachment" "logging_role_attachment" {
  name       = "logging-role-attachment"
  roles      = [aws_iam_role.logging_role.name]
  policy_arn = aws_iam_policy.logging_policy.arn
}
