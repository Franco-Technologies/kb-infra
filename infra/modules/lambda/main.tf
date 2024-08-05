# lambda authorizer terraform

# layer
resource "aws_lambda_layer_version" "this" {
  layer_name       = var.layer_name
  filename         = var.layer_filename
  source_code_hash = data.archive_file.layer.output_base64sha256

  compatible_runtimes = var.compatible_runtimes
}

# Zip the Lambda function source code
data "archive_file" "authorizer" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = var.output_path
}

# Role for the Lambda function
resource "aws_iam_role" "authorizer" {
  name = "authorizer-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      },

    ]
  })
}

resource "aws_lambda_function" "authorizer" {
  filename         = data.archive_file.authorizer.output_path
  function_name    = var.function_name
  role             = aws_iam_role.authorizer.arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  memory_size      = var.memory_size
  source_code_hash = data.archive_file.authorizer.output_base64sha256
  tags             = var.tags
}
