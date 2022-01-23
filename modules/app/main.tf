provider "aws" {
  region = var.aws_region
}
###########################################################################
# Find Networking
###########################################################################
data "aws_ami" "gr-app" {
  most_recent = true
  filter {
    name   = "name"
    values = ["${var.ami_name_search}*"]
  }
  owners = ["328381481838"]
}

data "aws_vpc" "gr-vpc"{
  filter {
    name   = "tag:name"
    values = [var.vpc_name]
  }
}

data aws_subnet_ids "gr-subnets"{
  vpc_id = data.aws_vpc.gr-vpc.id
}
###########################################################################
# App SG
###########################################################################
resource "aws_security_group" "app-sg" {
  name = "app-sg-public"
  description = "Allows public ssh and web"
  vpc_id = data.aws_vpc.gr-vpc.id
}
resource "aws_security_group_rule" "app-ssh" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.app-sg.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "app-web" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.app-sg.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks = ["0.0.0.0/0"]
}

###########################################################################
# App AMI
###########################################################################
resource "aws_instance" "app" {
  ami           = data.aws_ami.gr-app.id
  instance_type = "t3.micro"
  key_name = var.key_name
  security_groups = [aws_security_group.app-sg.id]
  associate_public_ip_address = true
  subnet_id = tolist(data.aws_subnet_ids.gr-subnets.ids)[var.subnet_index]
  tags = merge(var.common_tags)
}
###########################################################################
# Instance EIP
###########################################################################
resource "aws_eip" "gr-eip" {
  instance = aws_instance.app.id
  tags = merge(var.common_tags)
}
