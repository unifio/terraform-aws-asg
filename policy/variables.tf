# Input Variables

## Resource tags
variable "stack_item_label" {
}

variable "stack_item_fullname" {
}

## ASG parameters
variable "asg_name" {
}

## Notification parameters
variable "notifications" {
  default = "autoscaling:EC2_INSTANCE_LAUNCH,autoscaling:EC2_INSTANCE_TERMINATE,autoscaling:EC2_INSTANCE_LAUNCH_ERROR,autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
}

## Monitor parameters
variable "adjustment_type" {
  default = "PercentChangeInCapacity"
}

variable "scaling_adjustment" {
}

variable "cooldown" {
}

variable "min_adjustment_magnitude" {
  default = 1
}

variable "comparison_operator" {
  description = "Valid values are 'GreaterThanOrEqualToThreshold', 'GreaterThanThreshold', 'LessThanThreshold' and 'LessThanOrEqualToThreshold'"
}

variable "evaluation_periods" {
}

variable "metric_name" {
}

variable "name_space" {
  default = "AWS/EC2"
}

variable "period" {
}

variable "statistic" {
  description = "Valid values are 'SampleCount', 'Average', 'Sum', 'Minimum' and 'Maximum'"
  default     = "Average"
}

variable "threshold" {
}
