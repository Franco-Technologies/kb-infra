# VPC
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

# ECS
output "ecs_cluster_arn" {
  value = module.ecs.cluster_arn
}

# Load Balancer
output "load_balancer_dns_name" {
  value = module.load_balancer.load_balancer_dns_name
}

output "listener_arn" {
  value = module.load_balancer.listener_arn
}

output "load_balancer_arn" {
  value = module.load_balancer.load_balancer_arn
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
