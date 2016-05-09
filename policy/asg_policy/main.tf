# Auto Scaling Policy

## Creates simple absolute scaling policy
resource "aws_autoscaling_policy" "asg_policy" {
  count                  = "${lookup(var.selector, var.adjustment_type)}"
  name                   = "${var.stack_item_label}"
  autoscaling_group_name = "${var.asg_name}"
  adjustment_type        = "${var.adjustment_type}"
  scaling_adjustment     = "${var.scaling_adjustment}"
  cooldown               = "${var.cooldown}"
  policy_type            = "SimpleScaling"
}

## Creates simple percentage scaling policy
resource "aws_autoscaling_policy" "asg_policy_percent" {
  count                    = "${index(split(",",var.opposite),lookup(var.selector, var.adjustment_type))}"
  name                     = "${var.stack_item_label}"
  autoscaling_group_name   = "${var.asg_name}"
  adjustment_type          = "PercentChangeInCapacity"
  scaling_adjustment       = "${var.scaling_adjustment}"
  min_adjustment_magnitude = "${var.min_adjustment_magnitude}"
  cooldown                 = "${var.cooldown}"
  policy_type              = "SimpleScaling"
}
