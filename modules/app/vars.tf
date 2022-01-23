variable "aws_region" {
  type = string
  default = "us-east-2"
}

variable "ami_name_search" {
  type = string
  default = "gr-app"
}

variable "subnet_search" {
  type = string
  default = "main-gr"
}

variable "vpc_name" {
  type = string
  default = "mai-gr"
}

variable "subnet_index"{
  type = number
  default = 1
}

variable "instance_name" {
  type = string
  default = "gr-app"
}

variable "key_name" {
  type = string
  default = "admin"
}

variable "common_tags" {
  type = map
  default = {
    name = "not-set"
    env =  "not-set"
    app =  "not-set"
  }
}