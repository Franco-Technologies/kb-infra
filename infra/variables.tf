variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  default     = "admin123"
}
variable "dev_trusted_issuers" {
  description = "Trusted issuers for the dev environment"
  type        = string
  default     = "https://cognito-idp.us-east-2.amazonaws.com/us-east-2_vXgSMyGNJ"
}

variable "prod_trusted_issuers" {
  description = "Trusted issuers for the prod environment"
  type        = string
  default     = ""
}

# Add other environment-specific variables as needed
