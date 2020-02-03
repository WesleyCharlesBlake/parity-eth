### Auto Scaling Group

module "app-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name    = "parity-eth-asg"

  # Launch configuration
  #
  # launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  # create_lc = false # disables creation of launch configuration
  lc_name = "parity-eth-lc"

  image_id                     = data.aws_ami.parity-ami.id
  instance_type                = var.ec2_instance_type
  security_groups              = [data.aws_security_group.app.id]
  associate_public_ip_address  = false
  recreate_asg_when_lc_changes = true

  root_block_device = [
    {
      volume_size           = "10"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "app-asg"
  vpc_zone_identifier       = data.aws_subnet_ids.public.ids
  health_check_type         = "EC2"
  min_size                  = var.ec2_min_capacity
  max_size                  = var.ec2_max_capacity
  desired_capacity          = var.ec2_desired_capacity
  wait_for_capacity_timeout = 0
  key_name                  = var.ec2_key

  tags = [
    {
      key                 = "Environment"
      value               = var.environment_name
      propagate_at_launch = true
    },
    {
      key                 = "Service"
      value               = var.service_name
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = var.owner
      propagate_at_launch = true
    }
  ]
}

### bastion hosts
module "bastion-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"
  name    = "bastion-asg"

  lc_name = "bastion-lc"

  image_id                     = data.aws_ami.bastion.id
  instance_type                = "t2.small"
  security_groups              = [data.aws_security_group.bastion.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true

  root_block_device = [
    {
      volume_size           = "10"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "bastion"
  vpc_zone_identifier       = data.aws_subnet_ids.public.ids
  health_check_type         = "EC2"
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  key_name                  = var.ec2_key

  tags = [
    {
      key                 = "Environment"
      value               = var.environment_name
      propagate_at_launch = true
    },
    {
      key                 = "Service"
      value               = var.service_name
      propagate_at_launch = true
    },
    {
      key                 = "Owner"
      value               = var.owner
      propagate_at_launch = true
    }
  ]
}
