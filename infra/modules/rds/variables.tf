variable "env" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for RDS"
  type        = list(string)
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "13.7"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Allocated storage for RDS instance in GB"
  type        = number
  default     = 20
}

variable "db_username" {
  description = "Username for RDS instance"
  type        = string
}

variable "db_password" {
  description = "Password for RDS instance"
  type        = string
}