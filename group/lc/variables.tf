# Input Variables

## Resource tags
variable "stack_item_label" {
  type = "string"
}

variable "stack_item_fullname" {
  type = "string"
}

## VPC parameters
variable "vpc_id" {
  type = "string"
}

## LC parameters
variable "ami" {
  type = "string"
}

variable "instance_type" {
  type = "string"
}

variable "instance_profile" {
  type = "string"
}

variable "key_name" {
  type = "string"
}

variable "associate_public_ip_address" {
  type = "string"
}

variable "user_data" {
  type = "string"
}

variable "enable_monitoring" {
  type = "string"
}

variable "ebs_optimized" {
  type = "string"
}

variable "placement_tenancy" {
  type = "string"
}

variable "root_vol_type" {
  type = "string"
}

variable "root_vol_del_on_term" {
  type = "string"
}

variable "ebs_vol_type" {
  type = "string"
}

variable "ebs_device_name" {
  type = "string"
}

variable "ebs_snapshot_id" {
  type = "string"
}

variable "ebs_vol_del_on_term" {
  type = "string"
}

## Conditionals
variable "opposite" {
  type    = "string"
  default = "1,0"
}
