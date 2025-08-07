resource "aws_lb" "alb" {
  name               = "${var.name_prefix}-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnet_id
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false
  tags = var.tags
}
