### Data sources

data "aws_vpc" "parity-eth" {
  id = "${module.vpc.vpc_id}"
}

data "aws_security_group" "app" {
  vpc_id = data.aws_vpc.parity-eth.id
  name   = "${module.app_sg.this_security_group_name}"
}

data "aws_security_group" "bastion" {
  vpc_id = data.aws_vpc.parity-eth.id
  name   = "${module.ssh_sg.this_security_group_name}"
}

data "aws_subnet_ids" "private" {
  vpc_id = data.aws_vpc.parity-eth.id

  tags = {
    Name = "Private-App"
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.parity-eth.id

  tags = {
    Name = "Public"
  }
}

data "aws_ami" "parity-ami" {
  most_recent = true
  owners      = [var.aws_account_id]

  filter {
    name = "name"

    values = [
      "parity-*-${var.environment_name}",
    ]
  }
}

data "aws_ami" "bastion" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }
}