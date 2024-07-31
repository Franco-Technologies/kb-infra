locals { env = var.is_prod_branch == true ? ["prod"] : ["dev"] }

module "vpc" {
  source = "./modules/vpc"
  # Environment-specific variables
  vpc_cidr = var.vpc_cidr
  env      = var.env
}

module "ecs" {
  source = "./modules/ecs"
  # Environment-specific variables
  vpc_id = module.vpc.vpc_id
  env    = var.env
}

module "load_balancer" {
  source = "./modules/load_balancer"
  # Environment-specific variables
  env               = var.env
  subnet_ids        = module.vpc.private_subnet_ids
  vpc_id            = module.vpc.vpc_id
  security_group_id = module.vpc.default_security_group_id
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

module "rds" {
  source = "./modules/rds"
  # Environment-specific variables
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  env               = var.env
  db_instance_class = var.db_instance_class
  db_username       = var.db_username
  db_password       = var.db_password
}

module "api_gateway" {
  source = "./modules/api_gateway"
  # Environment-specific variables
  name               = "${var.env}-tenant-management-api"
  description        = "API Gateway for tenant management"
  endpoint_types     = ["REGIONAL"]
  authorization      = "NONE"
  request_parameters = {}
  stage_name         = var.env
  root_path_part     = "/"
  vpc_link_name      = "ecs-vpc-link"
  # target_arns        = [module.ecs.service_arn]
  # ecs_service_url    = module.ecs.service_url
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}
