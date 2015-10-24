# Output Variables

output "sg_id" {
  value = "${aws_security_group.sg_asg.id}"
}

output "lc_id" {
  value = "${aws_launch_configuration.lc.id}"
}

output "asg_id" {
  value = "${aws_autoscaling_group.asg.id}"
}
