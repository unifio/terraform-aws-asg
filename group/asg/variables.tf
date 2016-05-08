# Input Variables

## Resource tags
variable "stack_item_label" {
}

variable "stack_item_fullname" {
}

## VPC parameters
variable "subnets" {
}

## LC parameters
variable "lc_id" {
}

## ASG parameters
variable "max_size" {
}

variable "min_size" {
}

variable "hc_grace_period" {
}

variable "hc_check_type" {
}

variable "force_delete" {
}

variable "wait_for_capacity_timeout" {
}

variable "load_balancers" {
}

variable "min_elb_capacity" {
}

## Conditional toggle
variable "opposite" {
  type    = "string"
  default = "1,0"
}
