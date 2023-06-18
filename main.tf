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
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}


