# Input Variables

## Resource tags
variable "stack_item_fullname" {
  type = "string"
}

variable "stack_item_label" {
  type = "string"
}

## VPC parameters
variable "subnets" {
  type = "list"
}

## LC parameters
variable "lc_id" {
  type = "string"
}

## ASG parameters
variable "asg_name_prefix" {
  type = "string"
}

variable "default_cooldown" {
  type = "string"
}

variable "desired_capacity" {
  type = "string"
}

variable "enabled_metrics" {
  type = "list"
}

variable "force_delete" {
  type = "string"
}

variable "hc_check_type" {
  type = "string"
}

variable "hc_grace_period" {
  type = "string"
}

variable "max_size" {
  type = "string"
}

variable "metrics_granularity" {
  type = "string"
}

variable "min_size" {
  type = "string"
}

variable "placement_group" {
  type = "string"
}

variable "protect_from_scale_in" {
  type = "string"
}

variable "suspended_processes" {
  type = "list"
}

variable "termination_policies" {
  type = "list"
}

variable "wait_for_capacity_timeout" {
  type = "string"
}

## ELB parameters
variable "load_balancers" {
  type = "list"
}

variable "min_elb_capacity" {
  type = "string"
}

variable "target_group_arns" {
  type = "list"
}

variable "wait_for_elb_capacity" {
  type = "string"
}
