# Input Variables

## Resource tags
variable "stack_item_fullname" {
  type = string
}

variable "stack_item_label" {
  type = string
}

## Allow override of resource naming
variable "lc_sg_name_prefix_override" {
  type = string
}

## VPC parameters
variable "vpc_id" {
  type = string
}

## LC parameters
variable "associate_public_ip_address" {
  type = string
  default = "false"
}

variable "ami" {
  type = string
}

variable "ebs_optimized" {
  type = string
}

variable "ebs_vol_del_on_term" {
  type = string
}

variable "ebs_vol_device_name" {
  type = string
}

variable "ebs_vol_encrypted" {
  type = string
}

variable "ebs_vol_snapshot_id" {
  type = string
}

variable "ebs_vol_iops" {
  type = string
}

variable "ebs_vol_size" {
  type = string
}

variable "ebs_vol_type" {
  type = string
}

variable "enable_monitoring" {
  type = string
}

variable "instance_profile" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "key_name" {
  type = string
}

variable "placement_tenancy" {
  type = string
}

variable "root_vol_del_on_term" {
  type = string
}

variable "root_vol_iops" {
  type = string
}

variable "root_vol_size" {
  type = string
}

variable "root_vol_type" {
  type = string
}

variable "security_groups" {
  type = list(string)
}

variable "spot_price" {
  type = string
}

variable "user_data" {
  type = string
}

