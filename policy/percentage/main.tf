# Percentage capacity autoscaling configuration

## Creates simple scaling policy
resource "aws_autoscaling_policy" "asg_policy" {
  name                     = "${var.stack_item_label}"
  autoscaling_group_name   = "${var.asg_name}"
  adjustment_type          = "${var.adjustment_type}"
  scaling_adjustment       = "${var.scaling_adjustment}"
  cooldown                 = "${var.cooldown}"
  min_adjustment_magnitude = "${var.min_adjustment_magnitude}"
  policy_type              = "SimpleScaling"
}

## Creates Simple Notification Service (SNS) topic
resource "aws_sns_topic" "sns_asg" {
  name = "${var.stack_item_label}-asg"
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
  alarm_description   = "${var.stack_item_fullname}"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods  = "${var.evaluation_periods}"
  metric_name         = "${var.metric_name}"
  namespace           = "${var.name_space}"
  period              = "${var.period}"
  statistic           = "${var.statistic}"
  threshold           = "${var.threshold}"

  dimensions = {
    "AutoScalingGroupName" = "${var.asg_name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.asg_policy.arn}"]
}
