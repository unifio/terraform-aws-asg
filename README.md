# Terraform AWS Auto Scaling Module
[![Circle CI](https://circleci.com/gh/unifio/terraform-aws-asg/tree/master.svg?style=svg)](https://circleci.com/gh/unifio/terraform-aws-asg/tree/master)

Module stack supporting multiple deployment scenarios of an Auto Scaling Group to an AWS VPC.

## Prerequisites

* Pre-configured AWS VPC

## Requirements

* Terraform 0.6.16 or newer
* AWS provider

## Group Module

The group module will provision security group, launch configuration and auto scaling group resources. Both ELB and simple group configurations are supported.

## Input Variables

**Resource labels**
* `stack_item_label` - Short form identifier for this stack. This value is used to create the **Name** resource tag for resources created by this stack item, and also serves as a unique key for re-use.
* `stack_item_fullname` - Long form descriptive name for this stack item. This value is used to create the **application** resource tag for resources created by this stack item.
* `env` - Descriptive name for this stack's environment. This value is used to create the **tag** resource tag for resources created by this stack item.

**Virtual Private Cloud (VPC) parameters**
* `vpc_id` - ID of the target VPC.
* `region` - AWS region to be utilized.
* `subnets` - List of VPC subnets to associate with the auto scaling group.

**Launch configuration parameters**
* `ami` - Amazon Machine Image (AMI) to associate with the launch configuration.
* `instance_type` - EC2 instance type to associate with the launch configuration.
* `instance_profile` - IAM instance profile to associate with the launch configuration.
* `key_name` - SSH key pair to associate with the launch configuration.
* `associate_public_ip_address` - (Default: **false**) Flag for associating public IP addresses with instances managed by the auto scaling group.
* `user_data` - Instance initialization data to associate with the launch configuration.
* `enable_monitoring` - (Default: **true**) Flag to enable detailed monitoring.
* `ebs_optimized` - (Default: **false**) Flag to enable Elastic Block Storage (EBS) optimization.
* `placement_tenancy` - (Default: **default**) The tenancy of the instance. Valid values are **default** or **dedicated**.

**Block volume configuration**

NOTES: Ephemeral block device support to be implemented in a future version. Currently only offer support for a single additional volume in addition to **root**. Currently only support association of EBS snapshots.

* `root_vol_type` - (Default: **gp2**) The type of volume. Valid values are **standard** or **gp2**. (_While 'io1' is a valid type, this module does not currently expose the 'iops' parameter_).
* `root_vol_del_on_term` - (Default: **true**) Whether the volume should be destroyed on instance termination.
* `ebs_snapshot_id` - (Optional) The Snapshot ID to mount. (_This module currently only support association of snapshots. The following parameters are optional if this one is left unset_).
 * `ebs_vol_type` - (Default: **gp2**) The type of volume. Valid values are **standard** or **gp2**. (_While 'io1' is a valid type, this module does not currently expose the 'iops' parameter_).
 * `ebs_device_name` - The name of the device to mount.
 * `ebs_vol_del_on_term` - (Default: **true**) Whether the volume should be destroyed on instance termination.

**Auto scaling group parameters**

* `max_size` - Maximum number of instances allowed by the auto scaling group.
* `min_size` - Minimum number of instance to be maintained by the auto scaling group.
* `hc_grace_period` - Time allowed after an instance comes into service before checking health.
* `hc_check_type` - Type of health check performed by the auto scaling group. Valid values are **ELB** or **EC2**. (_Automatically set to 'EC2' when 'min_elb_capacity' is unset_).
* `force_delete` - (Default: **false**) Flag to allow deletion of the auto scaling group without waiting for all instances in the pool to terminate.
* `wait_for_capacity_timeout` - (Default: **10m**) A maximum duration that Terraform should wait for ASG managed instances to become healthy before timing out.
* `min_elb_capacity` - (Optional) Minimum number of healthy instances attached to the ELB that must be maintained during updates. (_The following parameters are optional if this one is left unset_).
 * `load_balancers` - List of load balancer names to associate with the auto scaling group.

### Usage

NOTE: These examples assume that valid AWS credentials have been provided as environment variables.

**Common**
```js
provider "aws" {
  region = "us-east-1"
}

resource "template_file" "user_data" {
  template = "${file("../templates/user_data.tpl")}"

  lifecycle {
    create_before_destroy = true
  }
}
```

**Basic ASG**
```js
module "simple_asg" {
  source              = "github.com/unifio/terraform-aws-asg//group"

  stack_item_label    = "app-prod"
  stack_item_fullname = "Application stack"
  vpc_id              = "vpc-0a74db6f"
  subnets             = "subnet-8c3ebefb,subnet-965bfecf,subnet-0db42f68"
  ami                 = "ami-5b7b726b"
  instance_type       = "t2.medium"
  instance_profile    = "terraform"
  key_name            = "ops"
  user_data           = "${template_file.user_data.rendered}"
  max_size            = 2
  min_size            = 2
  hc_grace_period     = 300
}
```

**ASG w/ ELB**
```js

resource "aws_elb" "elb" {
.
.
.
}

module "standard_asg" {
  source              = "github.com/unifio/terraform-aws-asg//group"

  stack_item_label    = "app-prod"
  stack_item_fullname = "Application stack"
  vpc_id              = "vpc-0a74db6f"
  subnets             = "subnet-8c3ebefb,subnet-965bfecf,subnet-0db42f68"
  ami                 = "ami-5b7b726b"
  instance_type       = "t2.medium"
  instance_profile    = "terraform"
  key_name            = "ops"
  user_data           = "${template_file.user_data.rendered}"
  max_size            = 2
  min_size            = 2
  hc_grace_period     = 300
  hc_check_type       = "ELB"
  min_elb_capacity    = 2
  load_balancers      = "${aws_elb.elb.id}"
}
```

### Outputs

* `sg_id` - ID of the security group
* `lc_id` - ID of the launch configuration
* `asg_id` - ID of the auto scaling group
* `asg_name` - Name of the auto scaling group

## Policy Module

The policy module will provision auto scaling policy, auto scaling notification, CloudWatch monitor and SNS topic resources. Both absolute and percentage based simple scaling schemes are supported.

### Input Variables

**Resource labels**
* `stack_item_label` - Short form identifier for this stack. This value is used to create the **Name** resource tag for resources created by this stack item, and also serves as a unique key for re-use.
* `stack_item_fullname` - Long form descriptive name for this stack item. This value is used to create the **application** resource tag for resources created by this stack item.

**Auto scaling group parameters**
* `asg_name` - Name of the ASG to associate the alarm with.

**Notification parameters**
* `notifications` - List of events to associate with the auto scaling notification.
  * Defaults (_Comma separated String_):
    * **autoscaling:EC2_INSTANCE_LAUNCH**
    * **autoscaling:EC2_INSTANCE_TERMINATE**
    * **autoscaling:EC2_INSTANCE_LAUNCH_ERROR**
    * **autoscaling:EC2_INSTANCE_TERMINATE_ERROR**

**Policy parameters**
* `adjustment_type` - Specifies the scaling adjustment.  Valid values are **ChangeInCapacity**, **ExactCapacity** and **PercentChangeInCapacity**.
* `scaling_adjustment` - The number of instances involved in a scaling action.
* `cooldown` - Seconds between auto scaling activities.
* `min_adjustment_magnitude` - (Default: **1**) Minimum number of instances to be involved in a scaling adjustment based on percentage of capacity.

**Monitor parameters**
* `comparison_operator` - Arithmetic operation to use when comparing the thresholds. Valid values are **GreaterThanOrEqualToThreshold**, **GreaterThanThreshold**, **LessThanThreshold** and **LessThanOrEqualToThreshold**.
* `evaluation_periods` - The number of periods over which data is compared to the specified threshold.
* `metric_name` - Name for the alarm's associated metric.
* `name_space` - (Default: **AWS/EC2**) The namespace for the alarm's associated metric.
* `period` - The period in seconds over which the specified statistic is applied.
* `statistic` - (Default: **Average**) The statistic to apply to the alarm's associated metric. Valid values are **SampleCount**, **Average**, **Sum**, **Minimum** and **Maximum**.
* `threshold` - The value against which the specified statistic is compared.

### Usage

NOTE: These examples assume that valid AWS credentials have been provided as environment variables.

**Common**
```js
provider "aws" {
  region = "us-east-1"
}
```

**Absolute policy**
```js
module "absolute_policy" {
  source              = "github.com/unifio/terraform-aws-asg//policy"

  stack_item_label    = "app-prod"
  stack_item_fullname = "Application stack"
  asg_name            = "example_asg"
  adjustment_type     = "ExactCapacity"
  scaling_adjustment  = 4
  cooldown            = 300
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  period              = 120
  threshold           = 10
}
```

**Percentage policy**
```js
module "percentage_policy" {
  source                   = "github.com/unifio/terraform-aws-asg//policy"

  stack_item_label         = "ops"
  stack_item_fullname      = "application"
  asg_name                 = "example_asg"
  adjustment_type          = "PercentChangeInCapacity"
  min_adjustment_magnitude = 2
  scaling_adjustment       = 4
  cooldown                 = 300
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 2
  metric_name              = "CPUUtilization"
  period                   = 120
  threshold                = 10
}
```

### Outputs

* `sns_arn` - Resource name of the Simple Notification Service (SNS) topic.

## Examples

See the [examples](examples) directory for a complete set of example source files.

## License ##

MPL 2.0. See LICENSE for full details.
