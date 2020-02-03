### Security Groups

module "app_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.0.1"

  name        = "app-sg"
  description = "Security group which is used by the application instances"
  vpc_id      = data.aws_vpc.parity-eth.id

  ingress_cidr_blocks = ["196.192.165.10/32"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 8645
      to_port     = 8645
      protocol    = "tcp"
      description = "Parity RPC port"
      cidr_blocks = "196.192.165.10/32"
    },
    {
      from_port   = 8646
      to_port     = 8646
      protocol    = "tcp"
      description = "Parity Websockets Port"
      cidr_blocks = "196.192.165.10/32"
    },
    {
      from_port   = 30305
      to_port     = 30305
      protocol    = "tcp"
      description = "Parity Network Port"
      cidr_blocks = "196.192.165.10/32"
    }
  ]

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "ssh-tcp"
      source_security_group_id = module.ssh_sg.this_security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules       = ["all-all"]

}


module "ssh_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.0.1"

  name        = "ssh-sg"
  description = "Security group which is to allow SSH from Bastion"
  vpc_id      = data.aws_vpc.parity-eth.id

  ingress_cidr_blocks = ["196.192.165.10/32"]
  ingress_rules       = ["ssh-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
}