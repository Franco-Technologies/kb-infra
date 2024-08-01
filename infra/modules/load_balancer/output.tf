output "load_balancer_dns_name" {
  value = aws_lb.main.dns_name
}

# output "listener_arn" {
#   value = aws_lb_listener.main.arn

# }
output "load_balancer_arn" {
  value = aws_lb.main.arn
}
