resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = var.description

  tags = var.tags
}

# Authorizer
resource "aws_api_gateway_authorizer" "this" {
  name           = "api_gateway_authorizer"
  rest_api_id    = aws_api_gateway_rest_api.this.id
  type           = "TOKEN"
  authorizer_uri = var.authorizer_uri

  identity_source = "method.request.header.Authorization"
}
resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}

# Root resource
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "v1"
}

# Method
resource "aws_api_gateway_method" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.this.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }
}

resource "aws_api_gateway_integration_response" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.this.http_method
  status_code = aws_api_gateway_method_response.this.status_code

  response_templates = {
    "application/json" = ""
  }
}

# Integration
resource "aws_api_gateway_integration" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.this.http_method

  type = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }

}

# deployment
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeployment = sha1(jsonencode({
      stage_name = var.stage_name,
    }))
  }
}


# logging
resource "aws_api_gateway_account" "demo" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cloudwatch" {
  name               = "api_gateway_cloudwatch_global"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "cloudwatch" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:FilterLogEvents",
    ]

    resources = ["*"]
  }
}
resource "aws_iam_role_policy" "cloudwatch" {
  name   = "default"
  role   = aws_iam_role.cloudwatch.id
  policy = data.aws_iam_policy_document.cloudwatch.json
}

resource "aws_cloudwatch_log_group" "api_gw_log_group" {
  name              = "/aws/api-gateway/${var.name}"
  retention_in_days = 14
}

# stage
resource "aws_api_gateway_stage" "this" {
  stage_name    = var.stage_name
  rest_api_id   = aws_api_gateway_rest_api.this.id
  deployment_id = aws_api_gateway_deployment.this.id


  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw_log_group.arn
    format = jsonencode({
      requestId          = "$context.requestId",
      ip                 = "$context.identity.sourceIp",
      caller             = "$context.identity.caller",
      user               = "$context.identity.user",
      requestTime        = "$context.requestTime",
      httpMethod         = "$context.httpMethod",
      path               = "$context.path",
      resourcePath       = "$context.resourcePath",
      status             = "$context.status",
      protocol           = "$context.protocol",
      responseLength     = "$context.responseLength",
      integrationLatency = "$context.integration.latency",
      errorMessage       = "$context.error.message",
      errorType          = "$context.error.type",
      responseBody       = "$context.response.body",
      integrationStatus  = "$context.integration.status",
      integrationError   = "$context.integration.error"
    })
  }


  tags = var.tags
}
