# Input Variables

## Resource tags
variable "app_label" {}
variable "app_name" {}

## VPC parameters
variable "vpc_id" {}
variable "subnets" {}

## LC parameters
variable "ami" {}
variable "instance_type" {}
variable "instance_profile" {}
variable "key_name" {}
variable "enable_monitoring" {
        default = true
}
variable "ebs_optimized" {
        default = true
}

## ASG parameters
variable "max_size" {}
variable "min_size" {}
variable "hc_grace_period" {}
variable "hc_check_type" {}
variable "force_delete" {
        default = false
}
variable "load_balancers" {}

## Context parameters
variable "user_data_template" {
        default = "user_data.tpl"
}
variable "domain" {}
variable "ssh_user" {}
