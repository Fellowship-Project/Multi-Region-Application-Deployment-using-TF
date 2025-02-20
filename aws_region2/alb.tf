# Create the Application Load Balancer
resource "aws_lb" "application_load_balancer" {
  name               = "public-loadbalancer-region2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = [aws_subnet.sub1.id, aws_subnet.sub2.id]
  enable_deletion_protection = false

  tags = {
    Name = "loadbalancer-region2"
  }
}


resource "aws_lb_listener" "alb_http_listener_80" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}




# Create target group with port 8080
resource "aws_lb_target_group" "alb_target_group" {
  name        = "target-group-region2"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = aws_vpc.myvpc.id


health_check {
  interval            = 30   # 30 seconds between health checks
  timeout             = 10   # Allow 10 seconds for the application to respond
  healthy_threshold   = 2    # Mark instance as healthy after 2 successful checks
  unhealthy_threshold = 2    # Mark instance as unhealthy after 2 failed checks
}

  lifecycle {
    create_before_destroy = true
  }
}




