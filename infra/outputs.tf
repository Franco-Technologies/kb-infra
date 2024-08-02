# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "vpc_endpoints" {
  value = module.vpc.vpc_endpoints
}

output "vpc_link_id" {
  value = module.vpc.vpc_link_id
}

output "vpc_link_sg_id" {
  value = module.vpc.vpc_link_sg_id
}

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

# Load Balancer
output "nlb_dns_name" {
  value = module.load_balancer.load_balancer_dns_name
}

output "nlb_arn" {
  value = module.load_balancer.load_balancer_arn
}

output "load_balancer_dns_name" {
  value = module.load_balancer.load_balancer_dns_name
}

output "listener_arn" {
  value = module.load_balancer.listener_arn
}

output "load_balancer_arn" {
  value = module.load_balancer.load_balancer_arn
}

output "target_group_arn" {
  value = module.load_balancer.target_group_arn
}

output "lb_security_group_id" {
  value = module.load_balancer.security_group_id
}

# output "rds_endpoint" {
#   value = module.rds.db_endpoint
# }

output "api_gateway_rest_api_id" {
  value = module.api_gateway.rest_api_id
}

output "api_gateway_root_resource_id" {
  value = module.api_gateway.root_resource_id
}

output "api_gateway_url" {
  value = module.api_gateway.api_gateway_url
}
