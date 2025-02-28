# Create an ALB
resource "aws_lb" "L1_CS_ALB" {
  name               = "L1-CS-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.L1_CS_ALB_SG.id]
  subnets            = [aws_default_subnet.default_subnet1.id, aws_default_subnet.default_subnet2.id]

  tags = {
    Name = "L1_CS_ALB"
  }
}

# Create a target group
resource "aws_lb_target_group" "L1_CS_ALB_TG" {
  name     = "L1-CS-ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_default_vpc.default.id
  target_type = "ip"

  health_check {
    path     = "/"
    port     = 80
    enabled  = true
    interval = 30
    protocol = "HTTP"
    matcher  = "200"
    timeout  = 5
  }

  tags = {
    Name = "L1_CS_ALB_TG"
  }
}

# Create a listener
resource "aws_lb_listener" "L1_CS_ALB_LISTENER" {
  load_balancer_arn = aws_lb.L1_CS_ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.L1_CS_ALB_TG.arn
  }
}