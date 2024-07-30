resource "aws_ecs_cluster" "main" {
  name = "${var.env}-tenant-management-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# resource "aws_ecs_task_definition" "app" {
#   family                   = "${var.env}-tenant-management-task"
#   network_mode             = "awsvpc"
#   requires_compatibilities = ["FARGATE"]
#   cpu                      = var.task_cpu
#   memory                   = var.task_memory

#   container_definitions = jsonencode([
#     {
#       name  = "tenant-management-container"
#       image = var.container_image
#       portMappings = [
#         {
#           containerPort = 80
#           hostPort      = 80
#         }
#       ]
#     }
#   ])
# }

# resource "aws_ecs_service" "app" {
#   name            = "${var.env}-tenant-management-service"
#   cluster         = aws_ecs_cluster.main.id
#   task_definition = aws_ecs_task_definition.app.arn
#   launch_type     = "FARGATE"
#   desired_count   = var.service_desired_count

#   network_configuration {
#     subnets         = var.subnet_ids
#     security_groups = [aws_security_group.ecs_tasks.id]
#   }
# }

# Add security group for ECS tasks