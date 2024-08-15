output "rest_api_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.this.id
}

output "api_gateway_url" {
  value = aws_api_gateway_deployment.this.invoke_url
}

output "root_resource_id" {
  value = aws_api_gateway_resource.root.id
}
