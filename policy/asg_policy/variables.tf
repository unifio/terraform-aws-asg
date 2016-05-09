# Input Variables

## Resource tags
variable "stack_item_label" {
}

## ASG parameters
variable "asg_name" {
}

## Policy parameters
variable "adjustment_type" {
}

variable "scaling_adjustment" {
}

variable "cooldown" {
}

variable "min_adjustment_magnitude" {
}

## Conditional toggles
variable "selector" {
  default = {
    ChangeInCapacity        = 1
    ExactCapacity           = 1
    PercentChangeInCapacity = 0
  }
}

variable "opposite" {
  type    = "string"
  default = "1,0"
}
