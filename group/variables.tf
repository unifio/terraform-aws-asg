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

variable "asg_name_override" {
  type        = string
  description = "A string to override the ASG name"
  default     = ""
}

variable "lc_sg_name_prefix_override" {
  type        = string
  description = "A string to override the ASG name"
  default     = ""
}

variable "propagate_name_at_launch" {
  type        = string
  description = "A string to override the ASG name"
  default     = "true"
}

## VPC parameters
variable "subnets" {
  type        = list(string)
  description = "A list of subnet IDs to launch resources in"
}

variable "vpc_id" {
  type        = string
  description = "ID of the target VPC."
}

## LC parameters
variable "ami" {
  type        = string
  description = "Amazon Machine Image (AMI) to associate with the launch configuration."
}

variable "associate_public_ip_address" {
  type        = string
  description = "Flag for associating public IP addresses with instances managed by the auto scaling group."
  default     = "false"
}

variable "ebs_optimized" {
  type        = string
  description = "Flag to enable EBS optimization."
  default     = "false"
}

variable "ebs_vol_del_on_term" {
  type        = string
  description = "Whether the volume should be destroyed on instance termination."
  default     = "true"
}

variable "ebs_vol_device_name" {
  type        = string
  description = "The name of the device to mount."
  default     = ""
}

variable "ebs_vol_encrypted" {
  type        = string
  description = "Whether the volume should be encrypted or not. Do not use this option if you are using 'snapshot_id' as the encrypted flag will be determined by the snapshot."
  default     = ""
}

/*
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
For the best per-I/O latency experience, we recommend that you provision an IOPS-to-GiB ratio greater than 2:1. For example, a 2,000 IOPS volume should be smaller than 1,000 GiB.
*/
variable "ebs_vol_iops" {
  type        = string
  description = "The amount of provisioned IOPS"
  default     = "2000"
}

variable "ebs_vol_size" {
  type        = string
  description = "The size of the volume in gigabytes."
  default     = ""
}

variable "ebs_vol_snapshot_id" {
  type        = string
  description = "The Snapshot ID to mount."
  default     = ""
}

variable "ebs_vol_type" {
  type        = string
  description = "The type of volume. Valid values are 'standard', 'gp2' and 'io1'."
  default     = "gp2"
}

variable "enable_monitoring" {
  type        = string
  description = "Flag to enable detailed monitoring."
  default     = ""
}

variable "instance_based_naming_enabled" {
  type        = string
  description = "Flag to enable instance-id based name tagging."
  default     = ""
}

variable "instance_name_prefix" {
  type        = string
  description = "Sring to prepend instance-id based name tags with."
  default     = ""
}

variable "instance_profile" {
  type        = string
  description = "IAM instance profile to associate with the launch configuration."
  default     = ""
}

variable "instance_tags" {
  type        = map(string)
  description = "Map of tags to add to isntances."

  default = {
    "" = ""
  }
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type to associate with the launch configuration."
}

variable "key_name" {
  type        = string
  description = "SSH key pair to associate with the launch configuration."
  default     = ""
}

variable "placement_tenancy" {
  type        = string
  description = "The tenancy of the instance. Valid values are 'default' or 'dedicated'."
  default     = "default"
}

variable "root_vol_del_on_term" {
  type        = string
  description = "Whether the volume should be destroyed on instance termination."
  default     = "true"
}

/*
http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html
For the best per-I/O latency experience, we recommend that you provision an IOPS-to-GiB ratio greater than 2:1. For example, a 2,000 IOPS volume should be smaller than 1,000 GiB.
*/
variable "root_vol_iops" {
  type        = string
  description = "The amount of provisioned IOPS"
  default     = "2000"
}

variable "root_vol_size" {
  type        = string
  description = "The size of the volume in gigabytes."
  default     = ""
}

variable "root_vol_type" {
  type        = string
  description = "The type of volume. Valid values are 'standard', 'gp2' and 'io1'."
  default     = "gp2"
}

variable "security_groups" {
  type        = list(string)
  description = "A list of associated security group IDs"
  default     = []
}

variable "spot_price" {
  type        = string
  description = "The price to use for reserving spot instances."
  default     = ""
}

variable "user_data" {
  type        = string
  description = "Instance initialization data to associate with the launch configuration."
  default     = ""
}

## ASG parameters
variable "additional_asg_tags" {
  type        = list(string)
  description = "Additional tags to apply at the ASG level, if any"
  default     = []
}

variable "default_cooldown" {
  type        = string
  description = "The amount of time, in seconds, after a scaling activity completes before another scaling activity can start."
  default     = ""
}

variable "desired_capacity" {
  type        = string
  description = "The number of Amazon EC2 instances that should be running in the group."
  default     = ""
}

variable "enabled_metrics" {
  type        = list(string)
  description = "A list of metrics to collect. The allowed values are 'GroupMinSize', 'GroupMaxSize', 'GroupDesiredCapacity', 'GroupInServiceInstances', 'GroupPendingInstances', 'GroupStandbyInstances', 'GroupTerminatingInstances', 'GroupTotalInstances'."
  default     = []
}

variable "force_delete" {
  type        = string
  description = "Flag to allow deletion of the auto scaling group without waiting for all instances in the pool to terminate."
  default     = "false"
}

variable "hc_check_type" {
  type        = string
  description = "Type of health check performed by the auto scaling group. Valid values are 'ELB' or 'EC2'."
  default     = ""
}

variable "hc_grace_period" {
  type        = string
  description = "Time allowed after an instance comes into service before checking health."
  default     = ""
}

variable "max_size" {
  type        = string
  description = "Maximum number of instances allowed by the auto scaling group."
}

variable "min_size" {
  type        = string
  description = "Minimum number of instance to be maintained by the auto scaling group."
}

variable "placement_group" {
  type        = string
  description = "The name of the placement group into which you'll launch your instances, if any."
  default     = ""
}

variable "protect_from_scale_in" {
  type        = string
  description = "Allows setting instance protection. The autoscaling group will not select instances with this setting for terminination during scale in events."
  default     = "false"
}

variable "suspended_processes" {
  type        = list(string)
  description = "A list of processes to suspend for the AutoScaling Group. The allowed values are 'Launch', 'Terminate', 'HealthCheck', 'ReplaceUnhealthy', 'AZRebalance', 'AlarmNotification', 'ScheduledActions', 'AddToLoadBalancer'. Note that if you suspend either the 'Launch' or 'Terminate' process types, it can prevent your autoscaling group from functioning properly."
  default     = []
}

variable "termination_policies" {
  type        = list(string)
  description = "A list of policies to decide how the instances in the auto scale group should be terminated. The allowed values are 'OldestInstance', 'NewestInstance', 'OldestLaunchConfiguration', 'ClosestToNextInstanceHour', 'Default'."
  default     = []
}

variable "wait_for_capacity_timeout" {
  type        = string
  description = "A maximum duration that Terraform should wait for ASG managed instances to become healthy before timing out."
  default     = ""
}

## ELB parameters
variable "load_balancers" {
  type        = list(string)
  description = "List of load balancer names to associate with the auto scaling group."
  default     = []
}

variable "min_elb_capacity" {
  type        = string
  description = "Minimum number of healthy instances attached to the ELB that must be maintained during updates."
  default     = ""
}

variable "target_group_arns" {
  type        = list(string)
  description = "A list of 'aws_alb_target_group' ARNs, for use with Application Load Balancing"
  default     = []
}

variable "wait_for_elb_capacity" {
  type        = string
  description = "Setting this will cause Terraform to wait for exactly this number of healthy instances in all attached load balancers on both create and update operations. (Takes precedence over 'min_elb_capacity' behavior.)"
  default     = ""
}

