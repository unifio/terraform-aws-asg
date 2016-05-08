# AWS Launch Configuration

## Creates security group
resource "aws_security_group" "sg_asg" {
  name_prefix = "${var.stack_item_label}-asg-"
  description = "${var.stack_item_fullname} security group"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name        = "${var.stack_item_label}-asg"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Creates launch configuration
resource "aws_launch_configuration" "lc" {
  count                       = "${index(split(",",var.opposite),signum(length(var.ebs_snapshot_id)))}"
  name_prefix                 = "${var.stack_item_label}-"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.sg_asg.id}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  ebs_optimized               = "${var.ebs_optimized}"
  placement_tenancy           = "${var.placement_tenancy}"

  root_block_device {
    volume_type           = "${var.root_vol_type}"
    delete_on_termination = "${var.root_vol_del_on_term}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "lc_ebs" {
  count                       = "${signum(length(var.ebs_snapshot_id))}"
  name_prefix                 = "${var.stack_item_label}-"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  iam_instance_profile        = "${var.instance_profile}"
  key_name                    = "${var.key_name}"
  security_groups             = ["${aws_security_group.sg_asg.id}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"
  enable_monitoring           = "${var.enable_monitoring}"
  ebs_optimized               = "${var.ebs_optimized}"
  placement_tenancy           = "${var.placement_tenancy}"

  root_block_device {
    volume_type           = "${var.root_vol_type}"
    delete_on_termination = "${var.root_vol_del_on_term}"
  }

  ebs_block_device {
    volume_type           = "${var.ebs_vol_type}"
    device_name           = "${var.ebs_device_name}"
    snapshot_id           = "${var.ebs_snapshot_id}"
    delete_on_termination = "${var.ebs_vol_del_on_term}"
  }

  lifecycle {
    create_before_destroy = true
  }
}
