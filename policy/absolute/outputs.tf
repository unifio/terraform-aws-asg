# Output Variables

output "sns_arn" {
  value = "${aws_sns_topic.asg_sns.arn}"
}
