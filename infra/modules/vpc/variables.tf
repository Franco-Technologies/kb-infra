variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

# variable "availability_zones" {
#   description = "List of availability zones"
#   type        = list(string)
# }
