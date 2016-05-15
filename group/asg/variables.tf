# Input Variables

## Resource tags
variable "stack_item_label" {
  type = "string"
}

variable "stack_item_fullname" {
  type = "string"
}

## VPC parameters
variable "subnets" {
  type = "string"
}

## LC parameters
variable "lc_id" {
  type = "string"
}

## ASG parameters
variable "max_size" {
  type = "string"
}

variable "min_size" {
  type = "string"
}

variable "hc_grace_period" {
  type = "string"
}

variable "hc_check_type" {
  type = "string"
}

variable "force_delete" {
  type = "string"
}

variable "wait_for_capacity_timeout" {
  type = "string"
}

variable "load_balancers" {
  type = "string"
}

variable "min_elb_capacity" {
  type = "string"
}
