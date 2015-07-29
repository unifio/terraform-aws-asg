# Output Variables

## Returns ID of the AWS Security Group
output "sg_id" {
        value = "${aws_security_group.sg_asg.id}"
}

## Returns ID of the Launch Configuration
output "lc_id" {
        value = "${aws_launch_configuration.lc.id}"
}

## Returns ID of the Autoscaling Group
output "asg_id" {
        value = "${aws_autoscaling_group.asg.id}"
}
