resource "aws_lb" "default" {

  name               = var.load_balancer_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_groud_id]
  subnets            = [for id in var.subnets_ids : id]

}

resource "aws_alb_target_group" "default" {
  name = var.aws_alb_target_group_name
  port = var.aws_alb_target_group_port
  protocol = var.aws_alb_target_group_protocol
  vpc_id = var.vpc_id
  health_check {
    interval = 30
    timeout = 5
    path = "/"
    unhealthy_threshold = 2
    healthy_threshold = 2
  }
  target_type = var.aws_alb_target_group_type

}

resource "aws_alb_listener" "default" {
  load_balancer_arn = aws_lb.default.arn
  port = var.aws_alb_listener_port
  protocol = var.aws_alb_listener_protocol
  default_action {
    target_group_arn = aws_alb_target_group.default.arn
    type = var.aws_alb_listener_default_action_type
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_alb_target_group.default.arn
  target_id        = var.aws_lb_target_group_attachment_instance_id
  port = var.aws_lb_target_group_attachment_port
}