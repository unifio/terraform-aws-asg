# Output Variables

output "sns_arn" {
  value = "${aws_sns_topic.asg-sns.arn}"
}
