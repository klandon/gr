locals {
  default_aws_region = "us-east-2"
}
module "state-bucket" {
  source = "../../modules/s3-replication"
  aws_region_main = local.default_aws_region
  aws_region_backup = "us-east-1"
  bucket_name = "gr-infra"
  env_type = "main"
  common_tags = {
    env = "main"
    role = "all-state"
  }
}

module "state-dynamo" {
 source = "../../modules/dynamo-ondemand"
 aws_region = local.default_aws_region
 env_type = "main"
 table_name = "gr-infra"
 common_tags = {
   env = "main"
   role = "all-state"
 }
}



#Commented out on first run Chicken and Egg
terraform {
  backend "s3" {
    bucket = "main-gr-infra"
    key    = "main-gr-infra/backend/terraform.tfstate"
    region = "us-east-2"
    dynamodb_table = "main-gr-infra"
    }
}