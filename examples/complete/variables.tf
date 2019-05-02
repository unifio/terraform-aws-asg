# Input Variables

## Resource tags
variable "stack_item_label" {
  type = string
}

variable "stack_item_fullname" {
  type = string
}

variable "env_tag" {
  type    = string
  default = ""
}

variable "team_tag" {
  type    = string
  default = ""
}

## VPC parameters
variable "vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "subnets" {
  type = string
}

## LC parameters
variable "ami" {
  type = string
}

variable "ebs_vol_device_name" {
  type = string
}

variable "ebs_vol_encrypted" {
  type    = string
  default = ""
}

variable "ebs_vol_size" {
  type    = string
  default = ""
}

variable "ebs_vol_snapshot_id" {
  type    = string
  default = ""
}

variable "enable_monitoring" {
  type    = string
  default = ""
}

variable "instance_based_naming_enabled" {
  type    = string
  default = ""
}

variable "instance_name_prefix" {
  type    = string
  default = ""
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type    = string
  default = ""
}

variable "root_vol_size" {
  type    = string
  default = ""
}

## ASG parameters
variable "desired_capacity" {
  type    = string
  default = ""
}

variable "max_size" {
  type = string
}

variable "min_elb_capacity" {
  type    = string
  default = ""
}

variable "min_size" {
  type = string
}

variable "wait_for_elb_capacity" {
  type    = string
  default = ""
}

## ELB parameters
variable "internal" {
  type    = string
  default = "true"
}

