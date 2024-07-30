variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
}

variable "env" {
  description = "Environment name (dev, staging, prod)"
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

variable "is_prod_branch" {
  description = "Flag to determine if the branch is prod"
  type        = bool
}

# Add other environment-specific variables as needed