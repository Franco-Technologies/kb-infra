variable "outputs" {
  description = "Map of outputs to store in SSM"
  type        = map(string)
  default     = {}
}

variable "param_name" {
  description = "Name of the SSM parameter"
  type        = string
}
