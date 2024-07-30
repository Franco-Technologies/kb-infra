resource "aws_api_gateway_rest_api" "this" {
  name        = var.name
  description = var.description

  endpoint_configuration {
    types = var.endpoint_types
  }

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
  authorization = var.authorization

  request_parameters = var.request_parameters
}

resource "aws_api_gateway_vpc_link" "this" {
  name = var.vpc_link_name

  target_arns = var.target_arns

  tags = var.tags
}

resource "aws_api_gateway_integration" "root_integration" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.root.id
  http_method             = aws_api_gateway_method.root_method.http_method
  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = var.ecs_service_url

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.this.id
}

resource "aws_api_gateway_deployment" "this" {
  depends_on = [aws_api_gateway_integration.root_integration]
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = var.stage_name
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.this.id
}

output "root_resource_id" {
  value = aws_api_gateway_resource.root.id
}

output "deployment_id" {
  value = aws_api_gateway_deployment.this.id
}

output "vpc_link_id" {
  value = aws_api_gateway_vpc_link.this.id
}
