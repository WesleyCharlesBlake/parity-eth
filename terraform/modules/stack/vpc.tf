### VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.7.0"

  name = "parity-eth-vpc"

  cidr = "10.10.0.0/16"

  azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets  = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets   = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]

  create_database_subnet_group = true

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true

  tags = {
    Owner       = var.owner
    Environment = var.environment_name
  }

  public_subnet_tags = {
    Name = "Public"
  }
  private_subnet_tags = {
    Name = "Private-App"
  }
  database_subnet_tags = {
    Name = "Private-DB"
  }
}