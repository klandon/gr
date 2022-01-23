
provider "aws" {
  region = var.aws_region
}
###########################################################################
# VPC
###########################################################################
resource "aws_vpc" "main-vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  tags = merge(var.common_tags)
  assign_generated_ipv6_cidr_block = false
}

###########################################################################
# Internet Access
###########################################################################
resource "aws_internet_gateway" "main-igw" {
  vpc_id = aws_vpc.main-vpc.id
  tags = merge(var.common_tags)
  depends_on = [aws_vpc.main-vpc]
}

###########################################################################
# Routing
###########################################################################
resource "aws_route" "main-internet" {
  route_table_id = aws_vpc.main-vpc.default_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.main-igw.id
  depends_on = [aws_vpc.main-vpc]
}

###########################################################################
# Subnets
###########################################################################
resource "aws_subnet" "main-pub-subnet" {
  for_each = var.subnets
  vpc_id = aws_vpc.main-vpc.id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone
  tags = merge(var.common_tags)
}

###########################################################################
# NACL
###########################################################################
resource "aws_default_network_acl" "main-default-nacl" {
  default_network_acl_id = aws_vpc.main-vpc.default_network_acl_id
  tags = merge(var.common_tags)
}

resource "aws_network_acl_rule" "main-all-out" {
  network_acl_id = aws_vpc.main-vpc.default_network_acl_id
  protocol       = "-1"
  egress = false
  cidr_block = "0.0.0.0/0"
  rule_action    = "allow"
  rule_number    = 100
  from_port = 0
  to_port = 0
  depends_on = [aws_vpc.main-vpc]
}


resource "aws_network_acl_rule" "main-all-in" {
  network_acl_id = aws_vpc.main-vpc.default_network_acl_id
  protocol       = "-1"
  egress = true
  cidr_block = "0.0.0.0/0"
  rule_action    = "allow"
  rule_number    = 100
  from_port = 0
  to_port = 0
  depends_on = [aws_vpc.main-vpc]
}

###########################################################################
# Default SG
###########################################################################

resource "aws_security_group" "admin-default-sg" {
  name = "main-default-sg"
  description = "generic sg for testing and break glass"
  vpc_id = aws_vpc.main-vpc.id
  tags = merge(var.common_tags)
  depends_on = [aws_vpc.main-vpc]
}

resource aws_security_group_rule "admin-http-access" {
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["${var.admin_ip}/32"]
  security_group_id = aws_security_group.admin-default-sg.id
}

resource aws_security_group_rule "admin-ssh-access" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${var.admin_ip}/32"]
  security_group_id = aws_security_group.admin-default-sg.id
}

resource aws_security_group_rule "admin-internet-access" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.admin-default-sg.id
}

resource aws_security_group_rule "vpc-local-access-out" {
  type = "egress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.vpc_cidr]
  security_group_id = aws_security_group.admin-default-sg.id
}

resource aws_security_group_rule "vpc-local-access-in" {
  type = "ingress"
  from_port = 0
  to_port = 0
  protocol = "-1"
  cidr_blocks = [var.vpc_cidr]
  security_group_id = aws_security_group.admin-default-sg.id
}


