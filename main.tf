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

