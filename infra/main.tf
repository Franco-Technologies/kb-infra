locals { env = var.is_prod_branch == true ? "prod" : "dev" }

module "vpc" {
  source = "./modules/vpc"
  # Environment-specific variables
  vpc_cidr = var.vpc_cidr
  env      = local.env
}

module "ecr" {
  source = "./modules/ecr"
  # Environment-specific variables
  app_name = var.app_name
  env      = local.env
}

module "load_balancer" {
  source = "./modules/load_balancer"
  # Environment-specific variables
  env        = local.env
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id     = module.vpc.vpc_id
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

module "ecs" {
  source = "./modules/ecs"
  # Environment-specific variables
  vpc_id = module.vpc.vpc_id
  env    = local.env
}

# module "rds" {
#   source = "./modules/rds"
#   # Environment-specific variables
#   vpc_id            = module.vpc.vpc_id
#   subnet_ids        = module.vpc.private_subnet_ids
#   env               = var.env
#   db_instance_class = var.db_instance_class
#   db_username       = var.db_username
#   db_password       = var.db_password
# }

module "api_gateway" {
  source = "./modules/api_gateway"
  # Environment-specific variables
  name               = "${local.env}-tenant-management-api"
  description        = "API Gateway for tenant management"
  endpoint_types     = ["REGIONAL"]
  authorization      = "NONE"
  request_parameters = {}
  stage_name         = local.env
  root_path_part     = "{proxy+}"
  alb_dns_name       = module.load_balancer.load_balancer_dns_name
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

module "ssm" {
  providers = {
    aws = aws.default
  }
  depends_on = [
    module.vpc,
    module.ecs,
    module.load_balancer,
    # module.rds,
    module.api_gateway
  ]
  source = "./modules/ssm"

  # Environment-specific variables
  param_name = "/${var.app_name}/${local.env}/appvars"
  outputs = {
    vpc_id                      = module.vpc.vpc_id
    public_subnet_ids           = jsonencode(module.vpc.public_subnet_ids)
    private_subnet_ids          = jsonencode(module.vpc.private_subnet_ids)
    ecr_repository_url          = module.ecr.ecr_repository_url
    ecs_cluster_arn             = module.ecs.cluster_arn
    ecs_task_execution_role_arn = module.ecs.role_arn
    load_balancer_dns_name      = module.load_balancer.load_balancer_dns_name
    load_balancer_sg_id         = module.load_balancer.security_group_id
    listener_arn                = module.load_balancer.listener_arn
    load_balancer_arn           = module.load_balancer.load_balancer_arn
    # rds_endpoint = module.rds.db_endpoint
    api_gateway_rest_api_id      = module.api_gateway.rest_api_id
    api_gateway_root_resource_id = module.api_gateway.root_resource_id
  }
}
