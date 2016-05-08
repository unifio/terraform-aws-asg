# Input Variables

## Resource tags
variable "stack_item_label" {
}

variable "stack_item_fullname" {
}

## VPC parameters
variable "vpc_id" {
}

variable "region" {
}

variable "subnets" {
}

## LC parameters
variable "ami" {
}

variable "instance_type" {
}

variable "instance_profile" {
}

variable "key_name" {
}

variable "associate_public_ip_address" {
  default = false
}

variable "user_data" {
}

variable "enable_monitoring" {
  default = true
}

variable "ebs_optimized" {
  default = false
}

variable "placement_tenancy" {
  default = "default"
}

variable "root_vol_type" {
  default = "gp2"
}

variable "root_vol_del_on_term" {
  default = true
}

variable "ebs_vol_type" {
  default = "gp2"
}

variable "ebs_device_name" {
  default = "/dev/xvda"
}

variable "ebs_snapshot_id" {
  default = ""
}

variable "ebs_vol_del_on_term" {
  default = true
}

## ASG parameters
variable "max_size" {
}

variable "min_size" {
}

variable "hc_grace_period" {
  default = "300"
}

variable "hc_check_type" {
  default = "ELB"
}

variable "force_delete" {
  default = false
}

variable "wait_for_capacity_timeout" {
  default = "10m"
}

variable "load_balancers" {
  type    = "string"
  default = ""
}

variable "min_elb_capacity" {
  type    = "string"
  default = ""
}
