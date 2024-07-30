locals { env = var.is_prod_branch == true ? ["prod"] : ["dev"] }

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../modules/vpc"
  # Environment-specific variables
  vpc_cidr     = var.vpc_cidr
  env          = var.env
}

module "ecs" {
  source = "../modules/ecs"
  # Environment-specific variables
  vpc_id       = module.vpc.vpc_id
  cluster_name = "${local.env}-tenant-management-cluster"
}

module "rds" {
  source = "../modules/rds"
  # Environment-specific variables
  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.private_subnet_ids
  db_instance_class = var.db_instance_class
  db_name           = "${local.env}_tenant_management"
}

module "api_gateway" {
  source = "../modules/api_gateway"
  # Environment-specific variables
  name = "${local.env}-tenant-management-api"
  description         = "API Gateway for tenant management"
  endpoint_types      = ["REGIONAL"]
  authorization       = "NONE"
  request_parameters  = {}
  stage_name          = local.env
  root_path_part      = "/"
  vpc_link_name       = "ecs-vpc-link"
  target_arns         = [module.ecs.service_arn]
  ecs_service_url     = module.ecs.service_url
  tags                = {
    Environment       = "dev"
    Project           = "example"
  }
}