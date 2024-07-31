output "vpc_id" {
  value = module.vpc.vpc_id
}

output "ecs_cluster_arn" {
  value = module.ecs.cluster_arn
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}

output "api_gateway_rest_api_id" {
  value = module.api_gateway.rest_api_id
}
