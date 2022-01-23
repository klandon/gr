
locals {
  default_aws_region = "us-east-2"
}

module "app-vpc" {
  source = "../../modules/vpc"
  aws_region = local.default_aws_region
  vpc_cidr = "10.0.0.0/24"
  common_tags = {
    env = "main"
    role = "all-state"
    name = "main-gr"
  }
  admin_ip = "75.165.131.27"
  subnets = {
    "pub-subnet-1" = {
      cidr_block = "10.0.0.0/25"
      availability_zone = "us-east-2b"
    },
    "pub-subnet-2" = {
      cidr_block = "10.0.0.128/25"
      availability_zone = "us-east-2c"
    }
  }
}

#Commented out on first run Chicken and Egg
terraform {
  backend "s3" {
    bucket = "main-gr-infra"
    key    = "main-gr-infra/backend/networking.tfstate"
    region = "us-east-2"
    dynamodb_table = "main-gr-infra"
  }
}

