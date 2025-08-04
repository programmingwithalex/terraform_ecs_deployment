################################################################################
# Application Load Balancer
################################################################################
resource "aws_alb" "alb" {
  name                       = "${var.project_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.lb_sg.id]
  subnets                    = [for subnet in aws_subnet.public : subnet.id]
  enable_deletion_protection = false # otherwise, `terraform destroy` will fail if the ALB is in use

  tags = {
    Environment = var.environment
  }
}

################################################################################
# ALB Target Group: For ECS tasks
################################################################################
resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name = "${var.project_name}-tg"
    Environment = var.environment
  }
}

################################################################################
# ALB Listener: Forwards HTTP to ECS target group
################################################################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
}
