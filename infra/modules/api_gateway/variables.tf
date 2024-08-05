variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "aws_region" {
  description = "The region in which the API Gateway is created"
  type        = string
  default     = "us-east-2"
}

variable "description" {
  description = "The description of the API Gateway"
  type        = string
  default     = ""
}

variable "endpoint_types" {
  description = "The endpoint types for the API Gateway"
  type        = list(string)
  default     = ["EDGE"]
}

variable "authorization" {
  description = "The authorization type for the API Gateway method"
  type        = string
  default     = "NONE"
}

variable "request_parameters" {
  description = "The request parameters for the API Gateway method"
  type        = map(string)
  default     = {}
}

variable "stage_name" {
  description = "The stage name for the deployment"
  type        = string
  default     = "prod"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "root_path_part" {
  description = "The root path part for the API Gateway"
  type        = string
  default     = "api"
}

variable "nlb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  type        = string
}

variable "nlb_arn" {
  description = "The ARN of the Network Load Balancer"
  type        = string
}

variable "authorizer_uri" {
  description = "The URI of the authorizer"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}
