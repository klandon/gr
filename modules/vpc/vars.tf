variable "aws_region" {
  type = string
  default = "us-east-2"
}

variable "vpc_cidr"{
  type = string
  default = "10.0.0.0"
}

variable "common_tags" {
  type = map
  default = {
    name = "not-set"
    env =  "not-set"
    app =  "not-set"
  }
}

variable "admin_ip" {
  type = string
  default = "172.16.0.0"
}

variable "subnets" {
  type        = map(object({
    cidr_block = string
    availability_zone = string
  }))
  description = "collection of subnets"
}

