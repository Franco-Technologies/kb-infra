resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = var.description

  # endpoint_configuration {
  #   types = var.endpoint_types
  # }

  tags = var.tags
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = var.root_path_part
}

resource "aws_api_gateway_method" "root_method" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_vpc_link" "this" {
  name        = "vpc-link"
  description = "VPC Link for API Gateway"
  target_arns = [var.nlb_arn]
  tags        = var.tags
}

resource "aws_api_gateway_integration" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.root_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${var.nlb_dns_name}/{proxy}"
  connection_type         = "VPC_LINK"
  connection_id           = aws_api_gateway_vpc_link.this.id
  timeout_milliseconds    = 29000

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
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


# deployment
resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  triggers = {
    redeployment = sha1(jsonencode({
      stage_name = var.stage_name,
    }))
  }
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
