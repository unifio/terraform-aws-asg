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

variable "user_data" {
}

variable "enable_monitoring" {
  default = true
}

variable "ebs_optimized" {
  default = false
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

variable "load_balancers" {
}

variable "min_elb_capacity" {
}
