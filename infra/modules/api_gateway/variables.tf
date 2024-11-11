variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "description" {
  description = "The description of the API Gateway"
  type        = string
  default     = ""
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

variable "authorizer_uri" {
  description = "The URI of the authorizer"
  type        = string
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}
