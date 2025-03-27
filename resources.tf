resource "aws_lb" "example_one" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-06aa2bdbe28342db1"]
  subnets            = ["subnet-0f80ea9f354297b8e", "subnet-034c71572324e4cfc"]

  enable_deletion_protection = false
  idle_timeout               = 60

  tags = {
    Name = "example-alb"
  }
}



resource "aws_lb_target_group" "example_one" {
  name     = "example-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-097e63d0baae37326"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "example-tg"
  }
}


resource "aws_lb_listener" "example_one" {
  load_balancer_arn = aws_lb.example_one.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_one.arn
  }
}


resource "aws_lb_listener_rule" "example_one" {
  listener_arn = aws_lb_listener.example_one.arne
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_one.arn
  }

  condition {
    host_header {
      values = ["example.com", "*.example.com"]
    }
  }
}


resource "aws_lb_listener_rule" "rule001" {
  listener_arn = aws_lb_listener.example_one.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_one.arn
  }

  condition {
    host_header {
      values = ["example1.com", "*.example1.com"]
    }
  }
}


variable "listener_rules" {
  type = map(object({
    priority     = number
    host_headers = list(string)
  }))
  default = {
    "rule1" = {
      priority     = 100
      host_headers = ["example.com", "*.example.com"]
    },
    "rule2" = {
      priority     = 200
      host_headers = ["test.com", "*.test.com"]
    }
  }
}


