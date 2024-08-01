output "cluster_arn" {
  value = aws_ecs_cluster.main.arn
}

output "role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}
