# Input Variables

## Resource tags
variable "stack_item_label" {
  type = "string"
}

## ASG parameters
variable "asg_name" {
  type = "string"
}

## Policy parameters
variable "adjustment_type" {
  type = "string"
}

variable "scaling_adjustment" {
  type = "string"
}

variable "cooldown" {
  type = "string"
}

variable "min_adjustment_magnitude" {
  type = "string"
}

## Conditional toggles
variable "selector" {
  type = "map"

  default = {
    ChangeInCapacity        = 1
    ExactCapacity           = 1
    PercentChangeInCapacity = 0
  }
}
