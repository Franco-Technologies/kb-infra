variable "name" {
  description = "The name of the API Gateway"
  type        = string
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

variable "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  type        = string
}
