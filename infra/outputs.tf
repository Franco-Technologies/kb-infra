# ECR
output "ecr_repository_url" {
  value = module.ecr.ecr_repository_url
}

# ECS
output "ecs_cluster_arn" {
  value = module.ecs.cluster_arn
}

output "ecs_task_execution_role_arn" {
  value = module.ecs.role_arn
}

# API Gateway
output "api_gateway_rest_api_id" {
  value = module.api_gateway.rest_api_id
}

output "api_gateway_root_resource_id" {
  value = module.api_gateway.root_resource_id
}

output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}
