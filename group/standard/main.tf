# AWS Autoscaling group

## Creates security group
resource "aws_security_group" "sg_asg" {
  description = "${var.stack_item_fullname} security group"
  vpc_id = "${var.vpc_id}"

  tags {
    Name = "${var.stack_item_label}-asg"
    application = "${var.stack_item_fullname}"
    managed_by = "terraform"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Creates launch configuration
resource "aws_launch_configuration" "lc" {
  image_id = "${var.ami}"
  instance_type = "${var.instance_type}"
  iam_instance_profile = "${var.instance_profile}"
  key_name = "${var.key_name}"
  security_groups = ["${aws_security_group.sg_asg.id}"]
  enable_monitoring = "${var.enable_monitoring}"
  ebs_optimized = "${var.ebs_optimized}"
  user_data = "${var.user_data}"

  lifecycle {
    create_before_destroy = true
  }
}

## Creates autoscaling group
resource "aws_autoscaling_group" "asg" {
  name = "asg-${var.stack_item_label}"
  max_size = "${var.max_size}"
  min_size = "${var.min_size}"
  launch_configuration = "${aws_launch_configuration.lc.id}"
  health_check_grace_period = "${var.hc_grace_period}"
  health_check_type = "${var.hc_check_type}"
  force_delete = "${var.force_delete}"
  min_elb_capacity = "${var.min_elb_capacity}"
  load_balancers = ["${split(",",var.load_balancers)}"]
  vpc_zone_identifier = ["${split(",",var.subnets)}"]

  tag {
    key = "application"
    value = "${var.stack_item_fullname}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}
