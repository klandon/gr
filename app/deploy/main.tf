locals {
  default_aws_region = "us-east-2"
}

module "app-instance" {
  source = "../../modules/app"
  ami_name_search = "gr-app"
  vpc_name = "main-gr"
  subnet_index = 0
  subnet_search = "main-gr"
  aws_region = "us-east-2"
  common_tags = {
    env = "main"
    role = "all-state"
    name = "main-gr"
  }
}

#Commented out on first run Chicken and Egg
terraform {
  backend "s3" {
    bucket = "main-gr-infra"
    key    = "main-gr-infra/backend/app.tfstate"
    region = "us-east-2"
    dynamodb_table = "main-gr-infra"
  }
}
