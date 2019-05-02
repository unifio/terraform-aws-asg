# Input Variables

## Resource tags
variable "stack_item_fullname" {
  type = string
}

variable "stack_item_label" {
  type = string
}

## VPC parameters
variable "subnets" {
  type = string
}

variable "region" {
  type = string
}

variable "vpc_id" {
  type = string
}

## LC parameters
variable "ami" {
  type = string
}

variable "associate_public_ip_address" {
  type    = string
  default = ""
}

variable "enable_monitoring" {
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

variable "security_groups" {
  type    = string
  default = ""
}

variable "spot_price" {
  type    = string
  default = ""
}

## ASG parameters
variable "default_cooldown" {
  type    = string
  default = ""
}

variable "desired_capacity" {
  type    = string
  default = ""
}

variable "enabled_metrics" {
  type    = string
  default = ""
}

variable "force_delete" {
  type    = string
  default = ""
}

variable "hc_grace_period" {
  type    = string
  default = ""
}

variable "max_size" {
  type = string
}

variable "min_size" {
  type = string
}

variable "protect_from_scale_in" {
  type    = string
  default = ""
}

variable "suspended_processes" {
  type    = string
  default = ""
}

variable "termination_policies" {
  type    = string
  default = ""
}

variable "wait_for_capacity_timeout" {
  type    = string
  default = ""
}

