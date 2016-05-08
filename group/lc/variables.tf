# Input Variables

## Resource tags
variable "stack_item_label" {
}

variable "stack_item_fullname" {
}

## VPC parameters
variable "vpc_id" {
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
}

variable "user_data" {
}

variable "enable_monitoring" {
}

variable "ebs_optimized" {
}

variable "placement_tenancy" {
}

variable "root_vol_type" {
}

variable "root_vol_del_on_term" {
}

variable "ebs_vol_type" {
}

variable "ebs_device_name" {
}

variable "ebs_snapshot_id" {
}

variable "ebs_vol_del_on_term" {
}

## Conditional toggle
variable "opposite" {
  type    = "string"
  default = "1,0"
}
