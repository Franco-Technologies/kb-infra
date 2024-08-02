# load balancer resource
resource "aws_lb" "main" {
  name               = "${var.env}-load-balancer"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnet_ids
  tags               = var.tags
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
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.vpc_link_sg_id]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
  }

  tags = var.tags

}

# listener resource
resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# target group resource
resource "aws_lb_target_group" "main" {
  name        = "${var.env}-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}
