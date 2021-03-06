terraform {
  backend "remote" {
    organization = "stratotechnology"
    workspaces {
      name = "parity-eth-prod"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "parity-eth" {
  source = "../modules/stack"

  aws_account_id = "994665119991"
  
  environment_name = "PROD"
  owner            = "DevOps"
  service_name     = "parity-eth"

  ec2_key           = "prod-us-east-1"
  ec2_instance_type = "t3.small"
  ec2_min_capacity = 1
  ec2_max_capacity = 1
  ec2_desired_capacity = 1

}