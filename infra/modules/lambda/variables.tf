variable "function_name" {
  description = "A unique name for the function"
  type        = string
  default     = "authorizer"
}

variable "handler" {
  description = "The entry point for the function"
  type        = string
  default     = "handler.lambda_handler"
}

variable "runtime" {
  description = "The runtime environment for the Lambda function"
  type        = string
  default     = "python3.8"
}

variable "timeout" {
  description = "The amount of time that Lambda allows a function to run before stopping it"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "The amount of memory that your function has access to"
  type        = number
  default     = 128
}

variable "environment" {
  description = "The Lambda function environment's configuration settings"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
}

variable "source_dir" {
  description = "The path to the directory containing the Lambda function source code"
  type        = string
  default     = "./src"
}

variable "output_path" {
  description = "The path to the file to write the zip archive to"
  type        = string
  default     = "./lambda-authorizer.zip"
}
