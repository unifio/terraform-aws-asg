# Outputs

output "sg_id" {
  value = "${aws_security_group.sg_asg.id}"
}

output "lc_id" {
  value = "${coalesce(aws_launch_configuration.lc.id, aws_launch_configuration.lc_ebs.id)}"
}
