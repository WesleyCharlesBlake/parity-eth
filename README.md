# Parity Etherium 

This repo provisions a Parity ETH client with CircleCI, Packer, Terraform on Amazon Web Services

## Packer

## Terraform

### Build Environment

The terraform configs located in [terraform/BUILD](terraform/BUILD) provions a dedicated build environment to be used for all packer builds. The VPC spans multiple AZs with multiple subnets for various usecases.

These resources need to be created first to ensure the sufficient network resources in your AWS account. The packer config makes use of the `vpc_filter` and `subnet_filter` to attach the packer builds to the correctly specified VPC and subnet. This ensure the build environment will not overlap with any other resources.

### Infrastructure

We make use of the following terraform modules:

* [terraform-aws-autoscaling](https://github.com/terraform-aws-modules/terraform-aws-autoscaling)
* [terraform-aws-alb](https://github.com/terraform-aws-modules/terraform-aws-alb)
* [terraform-aws-security-group](https://github.com/terraform-aws-modules/terraform-aws-security-group)

## Remote state and locking

Use of [terrafom enterpise](https://app.terraform.io/app/stratotechnology/workspaces) free tier. We have workspaces defined for each environment.

## Environments

We instrument our own custom terraform [modules](modules), which inherits config from the defined module sources, but allows us to set our own variables for PROD and QA.

The root config for each environment lives in the corresponding directory [terraform/QA](terraform/QA) or [terraform/PROD](terraform/PROD). We then reference the base module in our scripts as shown below:

```terraform
```

## CI/CD