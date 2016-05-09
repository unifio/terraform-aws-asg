# Outputs

output "policy_arn" {
  value = "${coalesce(aws_autoscaling_policy.asg_policy.arn, aws_autoscaling_policy.asg_policy_percent.arn)}"
}
