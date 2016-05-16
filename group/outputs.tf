# Outputs

output "sg_id" {
  value = "${module.lc.sg_id}"
}

output "lc_id" {
  value = "${module.lc.lc_id}"
}

output "asg_id" {
  value = "${module.asg.asg_id}"
}

output "asg_name" {
  value = "${module.asg.asg_name}"
}
