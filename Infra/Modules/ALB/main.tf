resource "aws_security_group" "app_alb_sg" {
  name_prefix = "app-alb-sg"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0          # Allow all ports for egress traffic
    to_port     = 0          # Allow all ports for egress traffic
    protocol    = "-1"       # All protocols
    cidr_blocks = ["0.0.0.0/0"]  # Allow traffic to anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP traffic from anywhere
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTPS traffic from anywhere
  }

  tags = {
    Name = "app-alb-sg"
  }
}


resource "aws_lb" "app_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.app_alb_sg.id]
  subnets            = var.subnets
  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
  enable_http2               = true

  tags = {
    Name = var.alb_name
  }
}

resource "aws_lb_target_group" "patient_tg" {
  name     = "patient-tg"
  port     = 3002
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_target_group" "appointment_tg" {
  name     = "appointment-tg"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  
default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.appointment_tg.arn
  }

}

resource "aws_lb_listener" "http_new" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = 80
  protocol          = "HTTP"
  
default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.patient_tg.arn
  }

}

