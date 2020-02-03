# Parity Etherium

## Build Status

### Production

[![CircleCI](https://circleci.com/gh/WesleyCharlesBlake/parity-eth/tree/master.svg?style=shield)](https://circleci.com/gh/WesleyCharlesBlake/parity-eth/tree/master)

### Develop

[![CircleCI](https://circleci.com/gh/WesleyCharlesBlake/parity-eth/tree/develop.svg?style=shield)](https://circleci.com/gh/WesleyCharlesBlake/parity-eth/tree/develop)


This repo provisions a Parity ETH client with CircleCI, Packer, Terraform on Amazon Web Services

## Packer

## Terraform

### Build Environment

The terraform configs located in [terraform/BUILD](terraform/BUILD) provions a dedicated build environment to be used for all packer builds in the respective AWS accounts. The VPC spans multiple AZs with multiple subnets for various usecases.

These resources need to be created first to ensure the sufficient network resources in your AWS account. The packer config makes use of the `vpc_filter` and `subnet_filter` to attach the packer builds to the correctly specified VPC and subnet. This ensure the build environment will not overlap with any other resources.

### Infrastructure

We make use of the following terraform modules:

* [terraform-aws-vpc](https://github.com/terraform-aws-modules/terraform-aws-vpc)
* [terraform-aws-autoscaling](https://github.com/terraform-aws-modules/terraform-aws-autoscaling)
* [terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group)

## Remote state and locking

Use of [terrafom enterpise](https://app.terraform.io/app/stratotechnology/workspaces) free tier. We have workspaces defined for each environment.

## Environments

We instrument our own custom terraform [modules](modules), which inherits config from the defined module sources, but allows us to set our own variables for PROD and DEV.

The root config for each environment lives in the corresponding directory [terraform/DEV](terraform/DEV) or [terraform/PROD](terraform/PROD). We then reference the base module in our scripts as shown below:

```terraform

provider "aws" {
  region = "us-east-1"
}

module "parity-eth" {
  source = "../modules/stack"

  aws_account_id = "<AWS_ACCOUNT_ID>"
  
  environment_name = "MyEnv"
  owner            = "SomePerson"
  service_name     = "parity-eth"

  ec2_key           = "some-key"
  ec2_instance_type = "t3.small"
  ec2_min_capacity = 1
  ec2_max_capacity = 1
  ec2_desired_capacity = 1
}
```

## TODO

- [ ] Configure multiple nodes to join
- [ ] SSL certificates on all enpoints
- [ ] Configure the parity service for correct use cases (ie mining etc)
- [ ] Publish the Terraform module to the terraform module registry
- [ ] semantic version and release on the repo (goes with publishing TF versions)
- [ ] Automate the build infra terraform as well