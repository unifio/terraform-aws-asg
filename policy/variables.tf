# Input Variables

## Resource tags
variable "stack_item_fullname" {
  type        = string
  description = "Long form descriptive name for this stack item. This value is used to create the 'application' resource tag for resources created by this stack item."
}

variable "stack_item_label" {
  type        = string
  description = "Short form identifier for this stack. This value is used to create the 'Name' resource tag for resources created by this stack item, and also serves as a unique key for re-use."
}

## ASG parameters
variable "asg_name" {
  type        = string
  description = "Name of the ASG to associate the alarm with."
}

## Notification parameters
variable "notifications" {
  type        = list(string)
  description = "List of events to associate with the auto scaling notification."
  default     = ["autoscaling:EC2_INSTANCE_LAUNCH", "autoscaling:EC2_INSTANCE_TERMINATE", "autoscaling:EC2_INSTANCE_LAUNCH_ERROR", "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"]
}

## Policy parameters
variable "adjustment_type" {
  type        = string
  description = "Specifies the scaling adjustment.  Valid values are 'ChangeInCapacity', 'ExactCapacity' or 'PercentChangeInCapacity'."
}

variable "cooldown" {
  type        = string
  description = "Seconds between auto scaling activities."
}

variable "scaling_adjustment" {
  type        = string
  description = "The number of instances involved in a scaling action."
}

## Monitor parameters
variable "comparison_operator" {
  type        = string
  description = "Arithmetic operation to use when comparing the thresholds. Valid values are 'GreaterThanOrEqualToThreshold', 'GreaterThanThreshold', 'LessThanThreshold' and 'LessThanOrEqualToThreshold'"
}

variable "evaluation_periods" {
  type        = string
  description = "The number of periods over which data is compared to the specified threshold."
}

variable "metric_name" {
  type        = string
  description = "Name for the alarm's associated metric."
}

variable "name_space" {
  type        = string
  description = "The namespace for the alarm's associated metric."
  default     = "AWS/EC2"
}

variable "period" {
  type        = string
  description = "The period in seconds over which the specified statistic is applied."
}

variable "statistic" {
  type        = string
  description = "The statistic to apply to the alarm's associated metric. Valid values are 'SampleCount', 'Average', 'Sum', 'Minimum' and 'Maximum'"
  default     = "Average"
}

variable "threshold" {
  type        = string
  description = "The value against which the specified statistic is compared."
}

variable "treat_missing_data" {
  type        = string
  description = "You can specfy how alarms handle missing data points. Valid values are 'missing': the alarm looks back farther in time to find additional data points, 'notBreaching': treated as a data point that is within the threshold, 'breaching': treated as a data point that is breaching the threshold, 'ignore': the current alarm state is maintained."
  default     = "missing"
}

variable "valid_missing_data" {
  type = map(string)

  default = {
    missing      = "missing"
    ignore       = "ignore"
    breaching    = "breaching"
    notBreaching = "notBreaching"
  }
}

variable "valid_statistics" {
  type = map(string)

  default = {
    Average     = "Average"
    Maximum     = "Maximum"
    Minimum     = "Minimum"
    SampleCount = "SampleCount"
    Sum         = "Sum"
  }
}

