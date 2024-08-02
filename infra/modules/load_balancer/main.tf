# Application Load Balancer
resource "aws_lb" "alb" {
  name               = "ecs-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name = "ecs-alb"
  }
}

# ALB Listener
resource "aws_lb_listener" "alb" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Hello, World. This is a static response."
      status_code  = "200"
    }
  }
}

# Security group resource
resource "aws_security_group" "lb_sg" {
  vpc_id = var.vpc_id
  name   = "${var.env}-lb-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  tags = var.tags

}

# target group resource
resource "aws_lb_target_group" "main" {
  name        = "${var.env}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

# Network Load Balancer
resource "aws_lb" "nlb" {
  name               = "ecs-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = var.subnet_ids
  security_groups    = [aws_security_group.lb_sg.id]

  enable_deletion_protection = false

  tags = {
    Name = "ecs-nlb"
  }
}

# NLB Listener
resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb.arn
  }
}

# NLB Target Group (pointing to ALB)
resource "aws_lb_target_group" "nlb" {
  name        = "ecs-nlb-tg"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "alb"
}

# Attach ALB to NLB Target Group
resource "aws_lb_target_group_attachment" "nlb_to_alb" {
  target_group_arn = aws_lb_target_group.nlb.arn
  target_id        = aws_lb.alb.arn
  port             = 80
}
