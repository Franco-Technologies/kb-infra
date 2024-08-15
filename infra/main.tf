locals { env = var.is_prod_branch == true ? "prod" : "dev" }

module "ecr" {
  source = "./modules/ecr"
  # Environment-specific variables
  app_name = var.app_name
  env      = local.env
}


module "ecs" {
  source = "./modules/ecs"
  # Environment-specific variables
  env = local.env
}

module "lambda" {
  source = "./modules/lambda"
  # Environment-specific variables
  environment = local.env
  tags = {
    Environment = "dev"
    Project     = "example"
  }
}

module "api_gateway" {
  source = "./modules/api_gateway"
  # Environment-specific variables
  name                 = "${local.env}-tenant-management-api"
  description          = "API Gateway for tenant management"
  stage_name           = local.env
  authorizer_uri       = module.lambda.qualified_invoke_arn
  lambda_function_name = module.lambda.function_name
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
    module.ecr,
    module.ecs,
    module.api_gateway
  ]
  source = "./modules/ssm"

  # Environment-specific variables
  param_name = "/${var.app_name}/${local.env}/appvars"
  outputs = {
    ecr_repository_url          = module.ecr.ecr_repository_url
    ecs_cluster_arn             = module.ecs.cluster_arn
    ecs_task_execution_role_arn = module.ecs.role_arn
    api_gateway_rest_api_id     = module.api_gateway.rest_api_id
  }
}
