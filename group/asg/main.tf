# AWS Auto Scaling Group

## Creates auto scaling group
resource "aws_autoscaling_group" "asg" {
  count                     = "${signum(length(var.min_elb_capacity)) + 1 % 2}"
  name                      = "${var.stack_item_label}-asg"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  launch_configuration      = "${var.lc_id}"
  health_check_grace_period = "${var.hc_grace_period}"
  health_check_type         = "EC2"
  force_delete              = "${var.force_delete}"
  vpc_zone_identifier       = ["${split(",",var.subnets)}"]
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  tag {
    key                 = "application"
    value               = "${var.stack_item_fullname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.stack_item_label}"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = ["aws_launch_configuration.lc"]
}

resource "aws_autoscaling_group" "asg_elb" {
  count                     = "${signum(length(var.min_elb_capacity))}"
  name                      = "${var.stack_item_label}"
  max_size                  = "${var.max_size}"
  min_size                  = "${var.min_size}"
  launch_configuration      = "${var.lc_id}"
  health_check_grace_period = "${var.hc_grace_period}"
  health_check_type         = "${var.hc_check_type}"
  force_delete              = "${var.force_delete}"
  min_elb_capacity          = "${var.min_elb_capacity}"
  load_balancers            = ["${split(",",var.load_balancers)}"]
  vpc_zone_identifier       = ["${split(",",var.subnets)}"]
  wait_for_capacity_timeout = "${var.wait_for_capacity_timeout}"

  tag {
    key                 = "application"
    value               = "${var.stack_item_fullname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${var.stack_item_label}"
    propagate_at_launch = true
  }
}
