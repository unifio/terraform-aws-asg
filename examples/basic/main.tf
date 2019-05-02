# Basic ASG Example

## Configures providers
provider "aws" {
  region = var.region
}

## Adds security group rules
resource "aws_security_group_rule" "sg_asg_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = -1
  security_group_id = module.example.sg_id
  to_port           = 0
  type              = "egress"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_asg_ssh" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  protocol          = "tcp"
  security_group_id = module.example.sg_id
  to_port           = 22
  type              = "ingress"

  lifecycle {
    create_before_destroy = true
  }
}

## Provisions basic autoscaling group
module "example" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//group"
  source = "../../group"

  # Resource tags
  stack_item_fullname = var.stack_item_fullname
  stack_item_label    = var.stack_item_label

  # VPC parameters
  subnets = [split(",", var.subnets)]
  vpc_id  = var.vpc_id

  # LC parameters
  ami                         = var.ami
  associate_public_ip_address = var.associate_public_ip_address
  enable_monitoring           = var.enable_monitoring
  instance_type               = var.instance_type
  key_name                    = var.key_name
  security_groups             = [split(",", var.security_groups)]
  spot_price                  = var.spot_price

  # ASG parameters
  default_cooldown          = var.default_cooldown
  desired_capacity          = var.desired_capacity
  enabled_metrics           = [split(",", var.enabled_metrics)]
  force_delete              = var.force_delete
  hc_grace_period           = var.hc_grace_period
  max_size                  = var.max_size
  min_size                  = var.min_size
  protect_from_scale_in     = var.protect_from_scale_in
  suspended_processes       = [split(",", var.suspended_processes)]
  termination_policies      = [split(",", var.termination_policies)]
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
}

