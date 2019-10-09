# Input Variables

## Resource tags
variable "stack_item_fullname" {
  type = string
}

variable "stack_item_label" {
  type = string
}

variable "additional_asg_tags" {
  type    = list(string)
  default = []
}

## Allow override of resource naming
variable "asg_name_override" {
  type = string
}

variable "propagate_name_at_launch" {
  type    = string
  default = "true"
}

## VPC parameters
variable "subnets" {
  type = list(string)
}

## LC parameters
variable "lc_id" {
  type = string
}

## ASG parameters

variable "default_cooldown" {
  type = string
}

variable "desired_capacity" {
  type = string
}

variable "enabled_metrics" {
  type = list(string)
}

variable "force_delete" {
  type = string
}

variable "hc_check_type" {
  type = string
}

variable "hc_grace_period" {
  type = string
}

variable "max_size" {
  type = string
}

variable "metrics_granularity" {
  type = string
}

variable "min_size" {
  type = string
}

variable "placement_group" {
  type = string
}

variable "protect_from_scale_in" {
  type = string
  default = "false"
}

variable "suspended_processes" {
  type = list(string)
}

variable "termination_policies" {
  type = list(string)
}

variable "wait_for_capacity_timeout" {
  type = string
}

## ELB parameters
variable "load_balancers" {
  type = list(string)
}

variable "min_elb_capacity" {
  type = string
}

variable "target_group_arns" {
  type = list(string)
}

variable "wait_for_elb_capacity" {
  type = string
}

