# Terraform AWS Auto Scaling Module
[![Circle CI](https://circleci.com/gh/unifio/terraform-aws-asg/tree/master.svg?style=svg)](https://circleci.com/gh/unifio/terraform-aws-asg/tree/master)

Module stack supporting multiple deployment scenarios of an Auto Scaling Group
to an AWS VPC.

## Prerequisites

* Pre-configured AWS VPC

## Requirements

* Terraform 0.8.0 or newer
* AWS provider

## Group Module

The group module will provision security group, launch configuration and auto
scaling group resources. Both ELB and simple group configurations are
supported.

## Input Variables

**Resource labels**
* `stack_item_fullname` - Long form descriptive name for this stack item. This
value is used to create the **application** resource tag for resources created
by this stack item.
* `stack_item_label` - Short form identifier for this stack. This value is used
to create the **Name** resource tag for resources created by this stack item,
and also serves as a unique key for re-use.

**Virtual Private Cloud (VPC) parameters**
* `region` - AWS region to be utilized.
* `subnets` - List of VPC subnets to associate with the auto scaling group.
* `vpc_id` - ID of the target VPC.

**Launch configuration parameters**
* `ami` - Amazon Machine Image (AMI) to associate with the launch configuration.
* `associate_public_ip_address` - (Optional) Flag for associating public IP
addresses with instances managed by the auto scaling group.
* `ebs_optimized` - (Default: **false**) Flag to enable Elastic Block Storage
(EBS) optimization.
* `enable_monitoring` - (Optional) Flag to enable detailed monitoring.
* `instance_based_naming_enabled` - (Optional) Flag to enable dynamic name tags
on instances. The default format is **stack_item_label-instance-id**. Requires
the instance to have the AWS CLI installed and an instance profile applied with
the **ec2:CreateTags** action granted for the given instance.
* `instance_name_prefix` - (Optional) String to replace **stack_item_label**
when `instance_based_naming_enabled` is set to **true**.
* `instance_profile` - (Optional) IAM instance profile to associate with the
launch configuration.
* `instance_tags` - (Optional) A map of key/value pairs to be applied as tags
to each instance. Requires the instance to have the AWS CLI installed and an
instance profile applied with the **ec2:CreateTags** action granted for the
given instance.
* `instance_type` - EC2 instance type to associate with the launch
configuration.
* `key_name` - (Optional) SSH key pair to associate with the launch
configuration.
* `placement_tenancy` - (Default: **default**) The tenancy of the instance.
Valid values are **default** or **dedicated**.
* `security_groups` - (Optional) A list of associated security group IDs.
* `spot_price` - (Optional) The price to use for reserving spot instances.
* `user_data` - (Optional) Instance initialization data to associate with the
launch configuration.

**Block volume configuration**

NOTES: Ephemeral block device support to be implemented in a future version.
Module currently only offers support for a single additional volume in addition to
**root**. All volume parameters are optional to the overall configuration, but
those not marked optional here are required when specifying a volume.

* `ebs_vol_del_on_term` - (Default: **true**) Whether the volume should be
destroyed on instance termination.
* `ebs_vol_device_name` - The name of the device to mount.
* `ebs_vol_encrypted` - (Optional) Whether the volume should be encrypted or
not. Value is ignored when `ebs_vol_snapshot_id` has been specified.
* `ebs_vol_iops` - (Default: **2000**) The amount of provisioned IOPS. Value
is ignored for any volume type other than `io1`.
* `ebs_vol_snapshot_id` - (Optional) The Snapshot ID to mount.
* `ebs_vol_size` - (Optional) The size of the volume in gigabytes.
* `ebs_vol_type` - (Default: **gp2**) The type of volume. Valid values are
**standard**, **gp2** or **io1**.
* `root_vol_del_on_term` - (Default: **true**) Whether the volume should be
destroyed on instance termination.
* `root_vol_iops` - (Default: **2000**) The amount of provisioned IOPS. Value
is ignored for any volume type other than `io1`.
* `root_vol_size` - (Optional) The size of the volume in gigabytes.
* `root_vol_type` - (Default: **gp2**) The type of volume. Valid values are
**standard**, **gp2** or **io1**.

**Auto scaling group parameters**

* `default_cooldown` - (Optional) The amount of time, in seconds, after a
scaling activity completes before another scaling activity can start.
* `desired_capacity` - (Optional) The number of Amazon EC2 instances that
should be running in the group.
* `enabled_metrics` - (Optional) A list of metrics to collect. The allowed
values are 'GroupMinSize', 'GroupMaxSize', 'GroupDesiredCapacity',
'GroupInServiceInstances', 'GroupPendingInstances', 'GroupStandbyInstances',
'GroupTerminatingInstances', 'GroupTotalInstances'.
* `force_delete` - (Default: **false**) Flag to allow deletion of the auto
scaling group without waiting for all instances in the pool to terminate.
* `hc_check_type` - (Optional) Type of health check performed by the auto
scaling group. Valid values are **ELB** or **EC2**. Automatically set to
**EC2** when **min_elb_capacity** and **wait_for_elb_capacity** are unset
and **ELB** when they are.
* `hc_grace_period` - (Optional) Time allowed after an instance comes into
service before checking health.
* `load_balancers` - (Optional) List of load balancer names to associate with the auto
 scaling group.
* `max_size` - Maximum number of instances allowed by the auto scaling group.
* `min_elb_capacity` - (Optional) Minimum number of healthy instances attached
to the ELB that must be maintained during updates.
* `min_size` - Minimum number of instance to be maintained by the auto scaling
group.
* `placement_group` - (Optional) The name of the placement group into which
you'll launch your instances, if any.
* `protect_from_scale_in` - (Optional) Allows setting instance protection. The
auto scaling group will not select instances with this setting for terminination
during scale in events.
* `suspended_processes` - (Optional) A list of processes to suspend for the
auto scaling group. The allowed values are 'Launch', 'Terminate', 'HealthCheck',
'ReplaceUnhealthy', 'AZRebalance', 'AlarmNotification', 'ScheduledActions',
'AddToLoadBalancer'. Note that if you suspend either the 'Launch' or
'Terminate' process types, it can prevent your auto scaling group from
functioning properly.
* `termination_policies` - (Optional) A list of policies to decide how the
instances in the auto scale group should be terminated. The allowed values are
'OldestInstance', 'NewestInstance', 'OldestLaunchConfiguration',
'ClosestToNextInstanceHour', 'Default'.
* `wait_for_capacity_timeout` - (Default: **10m**) A maximum duration that
Terraform should wait for ASG managed instances to become healthy before
timing out.
* `wait_for_elb_capacity` - Setting this will cause Terraform to wait for
exactly this number of healthy instances in all attached load balancers on both
create and update operations. (Takes precedence over 'min_elb_capacity'
behavior.)

### Usage

NOTE: These examples assume that valid AWS credentials have been provided as
environment variables.

**Common**
```js
provider "aws" {
  region = "us-east-1"
}

data "template_file" "user_data" {
  template = "${file("../templates/user_data.tpl")}"
}
```

**Basic ASG**
```js
module "asg" {
  source = "github.com/unifio/terraform-aws-asg//group"

  # Resource tags
  stack_item_fullname = "Application stack"
  stack_item_label    = "app-prod"

  # VPC parameters
  region  = "us-east-1"
  subnets = "subnet-3315e85a,subnet-3bbaaf43,subnet-ec1326a6"
  vpc_id  = "vpc-0f986c66"

  # LC parameters
  ami                           = "ami-0b33d91d"
  enable_monitoring             = true
  instance_based_naming_enabled = true
  instance_type                 = "m4.large"
  key_name                      = "ops"
  security_groups               = "sg-c1afc0a8,sg-7e33f32f"
  spot price                    = "0.010"
  user_data                     = "${template_file.user_data.rendered}"

  # ASG parameters
  max_size = 2
  min_size = 2
}
```

**ASG w/ ELB**
```js

resource "aws_elb" "elb" {
.
.
}

resource "aws_iam_instance_profile" "terraform" {
.
.
}

module "asg" {
  source = "github.com/unifio/terraform-aws-asg//group"

  # Resource tags
  stack_item_fullname = "Application stack"
  stack_item_label    = "app-prod"

  # VPC parameters
  region  = "us-east-1"
  subnets = "subnet-3315e85a,subnet-3bbaaf43,subnet-ec1326a6"
  vpc_id  = "vpc-0f986c66"

  # LC parameters
  ami                           = "ami-0b33d91d"
  ebs_vol_device_name           = "/dev/xvdb"
  ebs_vol_encrypted             = true
  ebs_vol_size                  = 2
  ebs_vol_snapshot_id           = "snap-62d9d283"
  enable_monitoring             = true
  instance_based_naming_enabled = true
  instance_name_prefix          = "supercool"
  instance_tags                 = "${map("env","production")}"
  instance_type                 = "t2.medium"
  instance_profile              = "${aws_iam_instance_profile.terraform.id}"
  key_name                      = "ops"
  user_data                     = "${template_file.user_data.rendered}"

  # ASG parameters
  desired_capacity = 2
  load_balancers   = "${aws_elb.elb.id}"
  max_size         = 3
  min_elb_capacity = 2
  min_size         = 1
}
```

### Outputs

* `asg_id` - ID of the auto scaling group
* `asg_name` - Name of the auto scaling group
* `lc_id` - ID of the launch configuration
* `sg_id` - ID of the security group

## Policy Module

The policy module will provision auto scaling policy, auto scaling
notification, CloudWatch monitor and SNS topic resources. Both absolute and
percentage based simple scaling schemes are supported.

### Input Variables

**Resource labels**
* `stack_item_fullname` - Long form descriptive name for this stack item. This
value is used to create the **application** resource tag for resources created
by this stack item.
* `stack_item_label` - Short form identifier for this stack. This value is used
to create the **Name** resource tag for resources created by this stack item,
and also serves as a unique key for re-use.

**Auto scaling group parameters**
* `asg_name` - Name of the ASG to associate the alarm with.

**Notification parameters**
* `notifications` - List of events to associate with the auto scaling
notification.
  * Defaults (_Comma separated String_):
    * **autoscaling:EC2_INSTANCE_LAUNCH**
    * **autoscaling:EC2_INSTANCE_TERMINATE**
    * **autoscaling:EC2_INSTANCE_LAUNCH_ERROR**
    * **autoscaling:EC2_INSTANCE_TERMINATE_ERROR**

**Policy parameters**
* `adjustment_type` - Specifies the scaling adjustment. Valid values are
**ChangeInCapacity**, **ExactCapacity** and **PercentChangeInCapacity**.
* `cooldown` - Seconds between auto scaling activities.
* `scaling_adjustment` - The number of instances involved in a scaling action.

**Monitor parameters**
* `comparison_operator` - Arithmetic operation to use when comparing the
thresholds. Valid values are **GreaterThanOrEqualToThreshold**,
**GreaterThanThreshold**, **LessThanThreshold** and
**LessThanOrEqualToThreshold**.
* `evaluation_periods` - The number of periods over which data is compared to
the specified threshold.
* `metric_name` - Name for the alarm's associated metric.
* `name_space` - (Default: **AWS/EC2**) The namespace for the alarm's
associated metric.
* `period` - The period in seconds over which the specified statistic is
applied.
* `statistic` - (Default: **Average**) The statistic to apply to the alarm's
associated metric. Valid values are **SampleCount**, **Average**, **Sum**,
**Minimum** and **Maximum**.
* `threshold` - The value against which the specified statistic is compared.
* [`treat_missing_data`](http://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/AlarmThatSendsEmail.html#alarms-and-missing-data) - (Default: **missing**) How alarms handle missing
data points. Valid values are:
  * **missing** - Missing (the alarm looks back farther in time to find additional data points)
  * **ignore** - Good ("Not Breaching," treated as a data point that is within the threshold)
  * **breaching** - Bad ("Breaching," treated as a data point that is breaching the threshold)
  * **notBreaching** - Ignored (the current alarm state is maintained)

### Usage

NOTE: These examples assume that valid AWS credentials have been provided as
environment variables.

**Common**
```js
provider "aws" {
  region = "us-east-1"
}
```

**Absolute policy**
```js
module "absolute_policy" {
  source = "github.com/unifio/terraform-aws-asg//policy"

  # Resource tags
  stack_item_fullname = "Application stack"
  stack_item_label    = "app-prod"

  # ASG parameters
  asg_name = "example_asg"

  # Monitor parameters
  adjustment_type     = "ExactCapacity"
  comparison_operator = "LessThanOrEqualToThreshold"
  cooldown            = 300
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  period              = 120
  scaling_adjustment  = 4
  threshold           = 10
  treat_missing_data  = "breaching"
}
```

**Percentage policy**
```js
module "percentage_policy" {
  source = "github.com/unifio/terraform-aws-asg//policy"

  # Resource tags
  stack_item_fullname      = "application"
  stack_item_label         = "ops"

  # ASG parameters
  asg_name = "example_asg"

  # Monitor parameters
  adjustment_type          = "PercentChangeInCapacity"
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  cooldown                 = 300
  evaluation_periods       = 2
  metric_name              = "CPUUtilization"
  period                   = 120
  scaling_adjustment       = 4
  threshold                = 10
  treat_missing_data       = "breaching"
}
```

### Outputs

* `sns_arn` - Resource name of the Simple Notification Service (SNS) topic.

## Examples

See the [examples](examples) directory for a complete set of example source
files.

## License ##

MPL 2.0. See LICENSE for full details.
