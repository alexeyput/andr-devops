# Create Application Load Balancer v2
resource "aws_alb" "alb" {
  name            = "terraform-example-alb"
  security_groups = [aws_security_group.http_sec_group.id]
  subnets         = [aws_subnet.public_subnet-A.id, aws_subnet.public_subnet-B.id]
  #    subnets         = ["aws_subnet.private_subnet-A.id", "aws_subnet.private_subnet-B.id"]
  tags = {
    Name: "${var.env_prefix}-ALB"
  }
}
# Create Listener
resource "aws_alb_listener" "listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }
}
# Create Target Groups for the Load Balancer
resource "aws_alb_target_group" "target_group" {
  name     = "alb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_tf.id
  target_type = "instance"
  health_check {
    path = "/"
    port = 80
  }
}

resource "aws_lb_target_group_attachment" "register-private-instance-A" {
  target_group_arn = aws_alb_target_group.target_group.arn
  target_id        = aws_instance.private-instance-A.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "register-private-instance-B" {
  target_group_arn = aws_alb_target_group.target_group.arn
  target_id        = aws_instance.private-instance-B.id
  port             = 80
}