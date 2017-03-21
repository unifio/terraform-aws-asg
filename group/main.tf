# AWS Auto Scaling Configuration

## Set Terraform version constraint
terraform {
  required_version = "> 0.8.0"
}

## Creates launch configuration & security group
module "lc" {
  source = "lc"

  ### Resource labels
  stack_item_fullname = "${var.stack_item_fullname}"
  stack_item_label    = "${var.stack_item_label}"

  ### VPC parameters
  vpc_id = "${var.vpc_id}"

  ### LC parameters
  ami                         = "${var.ami}"
  associate_public_ip_address = "${var.associate_public_ip_address}"
  ebs_optimized               = "${var.ebs_optimized}"
  ebs_vol_del_on_term         = "${var.ebs_vol_del_on_term}"
  ebs_vol_device_name         = "${var.ebs_vol_device_name}"
  ebs_vol_encrypted           = "${var.ebs_vol_encrypted}"
  ebs_vol_iops                = "${var.ebs_vol_iops}"
  ebs_vol_size                = "${var.ebs_vol_size}"
  ebs_vol_snapshot_id         = "${var.ebs_vol_snapshot_id}"
  ebs_vol_type                = "${var.ebs_vol_type}"
  enable_monitoring           = "${var.enable_monitoring}"
  instance_profile            = "${var.instance_profile}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  placement_tenancy           = "${var.placement_tenancy}"
  root_vol_del_on_term        = "${var.root_vol_del_on_term}"
  root_vol_iops               = "${var.root_vol_iops}"
  root_vol_size               = "${var.root_vol_size}"
  root_vol_type               = "${var.root_vol_type}"
  security_groups             = ["${var.security_groups}"]
  spot_price                  = "${var.spot_price}"
  user_data                   = "${var.user_data}"
}

## Creates auto scaling group
module "asg" {
  source = "asg"

  ### Resource tags
  stack_item_label    = "${var.stack_item_label}"
  stack_item_fullname = "${var.stack_item_fullname}"

  ### VPC parameters
  subnets = "${var.subnets}"

  ### LC parameters
  lc_id = "${module.lc.lc_id}"

  ### ASG parameters
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  hc_grace_period           = "${var.hc_grace_period}"
  hc_check_type             = "${var.hc_check_type}"
  force_delete              = "${var.force_delete}"
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"
  load_balancers            = "${var.load_balancers}"
  min_elb_capacity          = "${var.min_elb_capacity}"
}
