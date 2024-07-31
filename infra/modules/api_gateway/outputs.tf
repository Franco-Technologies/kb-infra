output "rest_api_id" {
  description = "The ID of the API Gateway"
  value       = aws_api_gateway_rest_api.this.id
}

output "root_resource_id" {
  description = "The ID of the root resource"
  value       = aws_api_gateway_resource.root.id
}

# output "deployment_id" {
#   description = "The ID of the deployment"
#   value       = aws_api_gateway_deployment.this.id
# }

# output "vpc_link_id" {
#   description = "The ID of the VPC Link"
#   value       = aws_api_gateway_vpc_link.this.id
# }
