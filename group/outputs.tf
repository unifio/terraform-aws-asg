# Outputs

output "asg_id" {
  value = "${module.asg.asg_id}"
}

output "asg_arn" {
  value = "${module.asg.asg_arn}"
}

output "asg_name" {
  value = "${module.asg.asg_name}"
}

output "lc_id" {
  value = "${module.lc.lc_id}"
}

output "sg_id" {
  value = "${module.lc.sg_id}"
}
