provider "aws" {
  region  = "eu-west-1"
  profile = "dave"
}

resource "aws_api_gateway_account" "gateway_account" {
  cloudwatch_role_arn = aws_iam_role.role_sketchy_router_logging.arn
}

resource "aws_api_gateway_rest_api" "vpn_api" {
  name        = "vpn-api"
  description = "This API controls my VPN EC2 instance I lovingly call Sketchy Router"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

/*
Resources
*/
resource "aws_api_gateway_resource" "resource_status" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  parent_id   = aws_api_gateway_rest_api.vpn_api.root_resource_id
  path_part   = "status"
}

resource "aws_api_gateway_resource" "resource_start" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  parent_id   = aws_api_gateway_rest_api.vpn_api.root_resource_id
  path_part   = "start"
}

resource "aws_api_gateway_resource" "resource_stop" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  parent_id   = aws_api_gateway_rest_api.vpn_api.root_resource_id
  path_part   = "stop"
}

/*
Methods
*/
resource "aws_api_gateway_method" "method_webui" {
  rest_api_id   = aws_api_gateway_rest_api.vpn_api.id
  resource_id   = aws_api_gateway_rest_api.vpn_api.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "method_status" {
  rest_api_id          = aws_api_gateway_rest_api.vpn_api.id
  resource_id          = aws_api_gateway_resource.resource_status.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.validator_antispider.id
  request_parameters = {
    "method.request.querystring.anti-spider" = true
  }
}

resource "aws_api_gateway_method" "method_start" {
  rest_api_id          = aws_api_gateway_rest_api.vpn_api.id
  resource_id          = aws_api_gateway_resource.resource_start.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.validator_antispider.id
  request_parameters = {
    "method.request.querystring.anti-spider" = true
  }
}

resource "aws_api_gateway_method" "method_stop" {
  rest_api_id          = aws_api_gateway_rest_api.vpn_api.id
  resource_id          = aws_api_gateway_resource.resource_stop.id
  http_method          = "GET"
  authorization        = "NONE"
  request_validator_id = aws_api_gateway_request_validator.validator_antispider.id
  request_parameters = {
    "method.request.querystring.anti-spider" = true
  }
}

/*
Request Validator
*/
resource "aws_api_gateway_request_validator" "validator_antispider" {
  name                        = "check-for-anti-spider-header"
  rest_api_id                 = aws_api_gateway_rest_api.vpn_api.id
  validate_request_parameters = true
}

/*
Method Responses
*/
resource "aws_api_gateway_method_response" "method_response_webui_200" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_rest_api.vpn_api.root_resource_id
  http_method = aws_api_gateway_method.method_webui.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
  response_models = {
    "text/html;charset=UTF-8" = "Empty"
  }
}

resource "aws_api_gateway_method_response" "method_response_status_200" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_resource.resource_status.id
  http_method = aws_api_gateway_method.method_status.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_stop_200" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_resource.resource_stop.id
  http_method = aws_api_gateway_method.method_stop.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_method_response" "method_response_start_200" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_resource.resource_start.id
  http_method = aws_api_gateway_method.method_start.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = true,
    "method.response.header.Access-Control-Allow-Methods"     = true,
    "method.response.header.Access-Control-Allow-Origin"      = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

/*
Integrations
*/
resource "aws_api_gateway_integration" "integration_webui" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_rest_api.vpn_api.root_resource_id
  http_method = aws_api_gateway_method.method_webui.http_method
  type = "MOCK"
  request_templates = {
    "application/json" : "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "aws_instance_status" {
  depends_on = [
    aws_iam_role.ec2_control
  ]
  rest_api_id             = aws_api_gateway_rest_api.vpn_api.id
  resource_id             = aws_api_gateway_resource.resource_status.id
  http_method             = aws_api_gateway_method.method_status.http_method
  type                    = "AWS"
  integration_http_method = "GET"
  uri                     = "arn:aws:apigateway:${var.region}:ec2:action/DescribeInstances"
  credentials             = aws_iam_role.ec2_control.arn

  request_parameters = {
    "integration.request.querystring.Version"      = "'2016-11-15'"
    "integration.request.querystring.InstanceId.1" = "'i-09050415bdac45809'"
  }
}

resource "aws_api_gateway_integration" "aws_instance_stop" {
  depends_on = [
    aws_iam_role.ec2_control
  ]
  rest_api_id             = aws_api_gateway_rest_api.vpn_api.id
  resource_id             = aws_api_gateway_resource.resource_stop.id
  http_method             = aws_api_gateway_method.method_stop.http_method
  type                    = "AWS"
  integration_http_method = "GET"
  uri                     = "arn:aws:apigateway:${var.region}:ec2:action/StopInstances"
  credentials             = aws_iam_role.ec2_control.arn

  request_parameters = {
    "integration.request.querystring.Version"      = "'2016-11-15'"
    "integration.request.querystring.InstanceId.1" = "'i-09050415bdac45809'"
  }
}

resource "aws_api_gateway_integration" "aws_instance_start" {
  depends_on = [
    aws_iam_role.ec2_control
  ]
  rest_api_id             = aws_api_gateway_rest_api.vpn_api.id
  resource_id             = aws_api_gateway_resource.resource_start.id
  http_method             = aws_api_gateway_method.method_start.http_method
  type                    = "AWS"
  integration_http_method = "GET"
  uri                     = "arn:aws:apigateway:${var.region}:ec2:action/StartInstances"
  credentials             = aws_iam_role.ec2_control.arn

  request_parameters = {
    "integration.request.querystring.Version"      = "'2016-11-15'"
    "integration.request.querystring.InstanceId.1" = "'i-09050415bdac45809'"
  }
}

/*
Integration Responses
*/
resource "aws_api_gateway_integration_response" "integration_response_webui_200" {
  depends_on = [
    aws_api_gateway_integration.integration_webui
  ]
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_rest_api.vpn_api.root_resource_id
  http_method = aws_api_gateway_method.method_webui.http_method
  status_code = aws_api_gateway_method_response.method_response_status_200.status_code
  response_templates = {
  "text/html" = file("index.html") }
}

resource "aws_api_gateway_integration_response" "integration_response_200" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_resource.resource_status.id
  http_method = aws_api_gateway_method.method_status.http_method
  status_code = aws_api_gateway_method_response.method_response_status_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'",
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200_stop" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_resource.resource_stop.id
  http_method = aws_api_gateway_method.method_stop.http_method
  status_code = aws_api_gateway_method_response.method_response_stop_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_api_gateway_integration_response" "integration_response_200_start" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id
  resource_id = aws_api_gateway_resource.resource_start.id
  http_method = aws_api_gateway_method.method_start.http_method
  status_code = aws_api_gateway_method_response.method_response_start_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"     = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods"     = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin"      = "'*'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

/*
Gateway Reponses
*/
resource "aws_api_gateway_gateway_response" "anti-spider-response" {
  rest_api_id   = aws_api_gateway_rest_api.vpn_api.id
  status_code   = "400"
  response_type = "BAD_REQUEST_PARAMETERS"

  response_templates = {
    "text/html; charset=utf-8" = "These aren't the droids you're looking for"
  }
}

/*
Stages and Deployment
*/
resource "aws_api_gateway_stage" "stage_prod" {
  depends_on    = [aws_cloudwatch_log_group.sketchy_router_logs]
  rest_api_id   = aws_api_gateway_rest_api.vpn_api.id
  stage_name    = "prod"
  deployment_id = aws_api_gateway_deployment.vpn_api_deployment.id
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.sketchy_router_logs.arn
    format          = file("stage-log-format.json")
  }
}

resource "aws_api_gateway_deployment" "vpn_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.vpn_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource_status.id,
      aws_api_gateway_resource.resource_stop.id,
      aws_api_gateway_resource.resource_start.id,
      aws_api_gateway_method.method_status.id,
      aws_api_gateway_method.method_stop.id,
      aws_api_gateway_method.method_start.id,
      aws_api_gateway_request_validator.validator_antispider.id,
      aws_api_gateway_integration.aws_instance_status.id,
      aws_api_gateway_integration.aws_instance_stop.id,
      aws_api_gateway_integration.aws_instance_start.id,
      aws_api_gateway_integration_response.integration_response_webui_200,
      aws_api_gateway_integration_response.integration_response_200,
      aws_api_gateway_integration_response.integration_response_200_stop,
      aws_api_gateway_integration_response.integration_response_200_start,
      aws_api_gateway_gateway_response.anti-spider-response.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

/*
Logging
*/
resource "aws_cloudwatch_log_group" "sketchy_router_logs" {
  name              = "sketchy_router_api"
  retention_in_days = 1
}

/*
Outputs
*/
output "api_url" {
  value = aws_api_gateway_stage.stage_prod.invoke_url
}
