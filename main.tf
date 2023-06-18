terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

resource "aws_security_group" "secGroup" {
  name        = "secGroup"
  description = "Allow Http inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "default" {
  ami                         = "ami-0889a44b331db0194"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.secGroup.id}"]
  key_name                    = "defaultKeypair"
  user_data_replace_on_change = true
  user_data_base64            = "IyEvYmluL2Jhc2gNCnN1ZG8geXVtIHVwZGF0ZSAteQ0Kc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwZA0Kc3VkbyBzeXN0ZW1jdGwgc3RhcnQgaHR0cGQNCnN1ZG8gc3lzdGVtY3RsIGVuYWJsZSBodHRwZA0Kc3VkbyB1c2VybW9kIC1hIC1HIGFwYWNoZSBlYzItdXNlcg0Kc3VkbyBjaG93biAtUiBlYzItdXNlcjphcGFjaGUgL3Zhci93d3cNCnN1ZG8gY2htb2QgMjc3NSAvdmFyL3d3dw0Kc3VkbyBmaW5kIC92YXIvd3d3IC10eXBlIGQgLWV4ZWMgY2htb2QgMjc3NSB7fSBcOw0Kc3VkbyBmaW5kIC92YXIvd3d3IC10eXBlIGYgLWV4ZWMgY2htb2QgMDY2NCB7fSBcOw0Kc3VkbyBlY2hvICI8P3BocCBwaHBpbmZvKCk7ID8+IiA+IC92YXIvd3d3L2h0bWwvcGhwaW5mby5waHA="

}

module "load_balancer" {
  source = "./load_balancer"

  vpc_id                                     = data.aws_vpc.main.id
  load_balancer_name                         = "default"
  load_balancer_type                         = "application"
  security_groud_id                          = aws_security_group.secGroup.id
  subnets_ids                                = data.aws_subnets.default.ids
  aws_alb_target_group_name                  = "my-alb-target-group"
  aws_alb_target_group_port                  = 80
  aws_alb_target_group_protocol              = "HTTP"
  aws_alb_target_group_type                  = "instance"
  aws_alb_listener_port                      = 80
  aws_alb_listener_protocol                  = "HTTP"
  aws_alb_listener_default_action_type       = "forward"
  aws_lb_target_group_attachment_port        = 80
  aws_lb_target_group_attachment_instance_id = aws_instance.default.id
}