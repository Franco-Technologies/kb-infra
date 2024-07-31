# ecr resource

resource "aws_ecr_repository" "repository" {
  name = var.app_name
  tags = {
    Environment = var.env
    Project     = "example"
  }
}
