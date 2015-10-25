# Absolute number autoscaling configuration

## Creates scaling policy
resource "aws_autoscaling_policy" "asg_policy" {
  name = "${var.stack_item_label}-policy"
  autoscaling_group_name = "${var.asg_name}"
  adjustment_type = "${var.adjustment_type}"
  scaling_adjustment = "${var.scaling_adjustment}"
  cooldown = "${var.cooldown}"
}

## Creates Simple Notification Service (SNS) topic
resource "aws_sns_topic" "asg_sns" {
  name = "${var.stack_item_label}-asg"
}

## Configures autoscaling notifications
resource "aws_autoscaling_notification" "asg_notify" {
  group_names = ["${var.asg_name}"]
  notifications  = ["${split(",",var.notifications)}"]
  topic_arn = "${aws_sns_topic.asg_sns.arn}"
}

## Creates CloudWatch monitor
resource "aws_cloudwatch_metric_alarm" "asg_monitor" {
  alarm_name = "${var.stack_item_label}-asg-monitor"
  alarm_description = "${var.stack_item_fullname}"
  comparison_operator = "${var.comparison_operator}"
  evaluation_periods = "${var.evaluation_periods}"
  metric_name = "${var.metric_name}"
  namespace = "${var.name_space}"
  period = "${var.period}"
  statistic = "${var.statistic}"
  threshold = "${var.threshold}"
  dimensions = {"AutoScalingGroupName" = "${var.asg_name}"}
  alarm_actions = ["${aws_autoscaling_policy.asg_policy.arn}"]
}
