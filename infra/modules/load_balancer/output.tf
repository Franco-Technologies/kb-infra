output "nlb_dns_name" {
  value = aws_lb.nlb.dns_name
}

output "nlb_arn" {
  value = aws_lb.nlb.arn
}

output "load_balancer_dns_name" {
  value = aws_lb.alb.dns_name
}

output "listener_arn" {
  value = aws_lb_listener.alb.arn

}
output "load_balancer_arn" {
  value = aws_lb.alb.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.main.arn
}

output "security_group_id" {
  value = aws_security_group.lb_sg.id
}
