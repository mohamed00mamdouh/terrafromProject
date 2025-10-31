# Public ALB
resource "aws_lb" "public" {
  name               = "public-alb"
  load_balancer_type = "application"
  security_groups    = []
  subnets            = var.public_subnets
}

# Internal ALB
resource "aws_lb" "internal" {
  name               = "int-alb"
  load_balancer_type = "application"
  internal           = true
  subnets            = var.private_subnets
}
