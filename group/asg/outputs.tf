# Outputs

output "asg_id" {
  value = "${coalesce(aws_autoscaling_group.asg.id, aws_autoscaling_group.asg_elb.id)}"
}

output "asg_name" {
  value = "${coalesce(aws_autoscaling_group.asg.name, aws_autoscaling_group.asg_elb.name)}"
}
