variable "vpc_id" {

  type        = string
  description = "Vpc id"
}

variable "region" {

  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "profile" {

  type        = string
  description = "AWS Profile"
  default     = "default"
}