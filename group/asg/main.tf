# AWS Auto Scaling Group

## Creates auto scaling group
resource "aws_autoscaling_group" "asg" {
  count = "${length(var.min_elb_capacity) > 0 || length(var.wait_for_elb_capacity) > 0 ? 0 : 1}"

  default_cooldown          = "${length(var.default_cooldown) > 0 ? var.default_cooldown : "300"}"
  desired_capacity          = "${length(var.desired_capacity) > 0 ? var.desired_capacity : var.min_size}"
  enabled_metrics           = ["${compact(var.enabled_metrics)}"]
  force_delete              = "${var.force_delete}"
  health_check_grace_period = "${length(var.hc_grace_period) > 0 ? var.hc_grace_period : "300"}"
  health_check_type         = "EC2"
  launch_configuration      = "${var.lc_id}"
  max_size                  = "${var.max_size}"
  metrics_granularity       = "${var.metrics_granularity}"
  min_size                  = "${var.min_size}"
  name                      = "${length(var.asg_name_override) > 0 ? var.asg_name_override : var.stack_item_label}"
  placement_group           = "${var.placement_group}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"
  suspended_processes       = ["${compact(var.suspended_processes)}"]
  target_group_arns         = ["${compact(var.target_group_arns)}"]
  termination_policies      = ["${compact(var.termination_policies)}"]
  vpc_zone_identifier       = ["${compact(var.subnets)}"]
  wait_for_capacity_timeout = "${length(var.wait_for_capacity_timeout) > 0 ? var.wait_for_capacity_timeout : "10m"}"

  tag {
    key                 = "application"
    value               = "${var.stack_item_fullname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${length(var.asg_name_override) > 0 ? var.asg_name_override : var.stack_item_label}"
    propagate_at_launch = true
  }

  tag {
    key                 = "managed_by"
    value               = "terraform"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "asg_elb" {
  count = "${length(var.min_elb_capacity) > 0 || length(var.wait_for_elb_capacity) > 0 ? 1 : 0}"

  default_cooldown          = "${length(var.default_cooldown) > 0 ? var.default_cooldown : "300"}"
  desired_capacity          = "${length(var.desired_capacity) > 0 ? var.desired_capacity : var.min_size}"
  enabled_metrics           = ["${compact(var.enabled_metrics)}"]
  force_delete              = "${var.force_delete}"
  health_check_grace_period = "${length(var.hc_grace_period) > 0 ? var.hc_grace_period : "300"}"
  health_check_type         = "${length(var.hc_check_type) > 0 ? var.hc_check_type : "ELB"}"
  launch_configuration      = "${var.lc_id}"
  load_balancers            = ["${compact(var.load_balancers)}"]
  max_size                  = "${var.max_size}"
  metrics_granularity       = "${var.metrics_granularity}"
  min_elb_capacity          = "${length(var.min_elb_capacity) > 0 ? var.min_elb_capacity : "0"}"
  min_size                  = "${var.min_size}"
  name                      = "${length(var.asg_name_override) > 0 ? var.asg_name_override : var.stack_item_label}"
  placement_group           = "${var.placement_group}"
  protect_from_scale_in     = "${var.protect_from_scale_in}"
  suspended_processes       = ["${compact(var.suspended_processes)}"]
  target_group_arns         = ["${compact(var.target_group_arns)}"]
  termination_policies      = ["${compact(var.termination_policies)}"]
  vpc_zone_identifier       = ["${compact(var.subnets)}"]
  wait_for_capacity_timeout = "${length(var.wait_for_capacity_timeout) > 0 ? var.wait_for_capacity_timeout : "10m"}"
  wait_for_elb_capacity     = "${length(var.wait_for_elb_capacity) > 0 ? var.wait_for_elb_capacity : "0"}"

  tag {
    key                 = "application"
    value               = "${var.stack_item_fullname}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "${length(var.asg_name_override) > 0 ? var.asg_name_override : var.stack_item_label}"
    propagate_at_launch = true
  }

  tag {
    key                 = "managed_by"
    value               = "terraform"
    propagate_at_launch = true
  }
}
