variable "env" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

# variable "subnet_ids" {
#   description = "Subnet IDs for ECS tasks"
#   type        = list(string)
# }


# variable "container_image" {
#   description = "Docker image for the application"
#   type        = string
# }

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory for the ECS task"
  type        = number
  default     = 512
}

variable "service_desired_count" {
  description = "Desired number of instances of the task to run"
  type        = number
  default     = 1
}
