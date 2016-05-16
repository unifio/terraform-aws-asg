# Percentage capacity autoscaling configuration

## Creates simple scaling policy
module "asg_policy" {
  source = "asg_policy"

  stack_item_label         = "${var.stack_item_label}"
  asg_name                 = "${var.asg_name}"
  adjustment_type          = "${var.adjustment_type}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  cooldown                 = "${var.cooldown}"
  min_adjustment_magnitude = "${var.min_adjustment_magnitude}"
}

## Creates Simple Notification Service (SNS) topic
resource "aws_sns_topic" "sns_asg" {
  name         = "${var.stack_item_label}-asg"
  display_name = "${var.stack_item_fullname} ASG SNS topic"
}

## Configures autoscaling notifications
resource "aws_autoscaling_notification" "asg_notify" {
  group_names   = ["${var.asg_name}"]
  notifications = ["${split(",",var.notifications)}"]
  topic_arn     = "${aws_sns_topic.sns_asg.arn}"
}

## Creates CloudWatch monitor
resource "aws_cloudwatch_metric_alarm" "monitor_asg" {
  alarm_name          = "${var.stack_item_label}-asg"
  alarm_description   = "${var.stack_item_fullname} ASG Monitor"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "${var.name_space}"
  period              = "${var.period}"
  statistic           = "${lookup(var.valid_statistics, var.statistic)}"
  threshold           = "${var.threshold}"

  dimensions = {
    "AutoScalingGroupName" = "${var.asg_name}"
  }

  actions_enabled = true
  alarm_actions   = ["${module.asg_policy.policy_arn}"]
}
