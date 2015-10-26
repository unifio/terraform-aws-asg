# Terraform AWS Auto Scaling Module #
[![Circle CI](https://circleci.com/gh/unifio/terraform-aws-asg/tree/master.svg?style=svg)](https://circleci.com/gh/unifio/terraform-aws-asg/tree/master)

Module stack supporting multiple deployment scenarios of an Auto Scaling Group to an AWS VPC.

## Prerequisites ##

- Pre-configured AWS VPC

## Requirements ##

- Terraform 0.6.4 or newer
- AWS provider

## Basic Group Module ##

The `basic` group module sets up an auto scaling group for simple automated failover within a VPC.

### Input Variables ###

- `stack_item_label` - Short form identifier for this stack. This value is used to create the "Name" resource tag for resources created by this stack item, and also serves as a unique key for re-use.
- `stack_item_fullname` - Long form descriptive name for this stack item. This value is used to create the "application" resource tag for resources created by this stack item.
- `vpc_id` - ID of the target VPC.
- `region` - EC2 region to be utilized.
- `subnets` - List of VPC subnets to be utilized.
- `ami` - AMI to associate with the launch configuration.
- `instance_type` - EC2 instance type to associate with the launch configuration.
- `instance_profile` - IAM instance profile to associate with the launch configuration.
- `key_name` - SSH key pair to associate with the launch configuration.
- `user_data` - User data to associate with the launch configuration.
- `enable_monitoring` - Flag to enable detailed monitoring. Defaults to 'true'.
- `ebs_optimized` - Flag to enable EBS optimization. Defaults to 'true'.
- `max_size` - Maximum number of instances allowed by the auto scaling group.
- `min_size` - Minimum number of instance to be maintained by the auto scaling group.
- `hc_grace_period` - Time allowed after an instance comes into service before checking health.
- `hc_check_type` - Type of health check performed by the auto scaling group. Choice of 'ELB' or 'EC2'.
- `force_delete` - Flag to allow deletion of the auto scaling group without waiting for all instances in the pool to terminate. Defaults to 'false'.

### Usage ###

The usage examples assume a configured AWS provider is present in the calling template.

```js
module "asg_basic" {
  source = "github.com/unifio/terraform-aws-asg//group/basic"

  stack_item_label = "ops"
  stack_item_fullname = "application"
  vpc_id = "vpc-0a74db6f"
  subnets = "subnet-8c3ebefb,subnet-965bfecf,subnet-0db42f68"
  ami = "ami-5b7b726b"
  instance_type = "t2.medium"
  instance_profile = "terraform"
  key_name = "ops"
  domain = "unif.io"
  ebs_optimized = "false"
  max_size = "2"
  min_size = "2"
  hc_grace_period = "300"
  hc_check_type = "EC2"
}
```

### Outputs ###

- `sg_id` - ID of the security group
- `lc_id` - ID of the launch configuration
- `asg_id` - ID of the auto scaling group
- `asg_name` - Name of the auto scaling group

## Standard Group Module ##

The `standard` group module sets up an auto scaling group for dynamic scaling behind an ELB.

### Input Variables ###

- `stack_item_label` - Short form identifier for this stack. This value is used to create the "Name" resource tag for resources created by this stack item, and also serves as a unique key for re-use.
- `stack_item_fullname` - Long form descriptive name for this stack item. This value is used to create the "application" resource tag for resources created by this stack item.
- `vpc_id` - ID of the target VPC.
- `region` - EC2 region to be utilized.
- `subnets` - List of VPC subnets to be utilized.
- `ami` - AMI to associate with the launch configuration.
- `instance_type` - EC2 instance type to associate with the launch configuration.
- `instance_profile` - IAM instance profile to associate with the launch configuration.
- `key_name` - SSH key pair to associate with the launch configuration.
- `user_data` - User data to associate with the launch configuration.
- `enable_monitoring` - Flag to enable detailed monitoring. Defaults to 'true'.
- `ebs_optimized` - Flag to enable EBS optimization. Defaults to 'true'.
- `max_size` - Maximum number of instances allowed by the auto scaling group.
- `min_size` - Minimum number of instance to be maintained by the auto scaling group.
- `hc_grace_period` - Time allowed after an instance comes into service before checking health.
- `hc_check_type` - Type of health check performed by the auto scaling group. Choice of 'ELB' or 'EC2'.
- `force_delete` - Flag to allow deletion of the auto scaling group without waiting for all instances in the pool to terminate. Defaults to 'false'.
- `load_balancers` - List of load balancer names to associate with the auto scaling group.
- `min_elb_capacity` - Minimum number of healthy instances attached to the ELB that must be maintained during updates.

### Usage ###

The usage examples assume a configured AWS provider is present in the calling template.

```js
module "asg" {
  source = "github.com/unifio/terraform-aws-asg//group/standard"

  stack_item_label = "ops"
  stack_item_fullname = "application"
  vpc_id = "vpc-0a74db6f"
  subnets = "subnet-8c3ebefb,subnet-965bfecf,subnet-0db42f68"
  ami = "ami-5b7b726b"
  instance_type = "t2.medium"
  instance_profile = "terraform"
  key_name = "ops"
  domain = "unif.io"
  ebs_optimized = "false"
  max_size = "6"
  min_size = "2"
  hc_grace_period = "300"
  hc_check_type = "ELB"
  load_balancers = "application-elb"
}
```

### Outputs ###

- `sg_id` - ID of the security group
- `lc_id` - ID of the launch configuration
- `asg_id` - ID of the auto scaling group
- `asg_name` - Name of the auto scaling group

## Absolute Policy Module ##

The `absolute` policy module sets up the policies, notifications and monitors to scale an auto scaling group by exact amounts.

### Input Variables ###

- `stack_item_label` - Short form identifier for this stack. This value is used to create the "Name" resource tag for resources created by this stack item, and also serves as a unique key for re-use.
- `stack_item_fullname` - Long form descriptive name for this stack item. This value is used to populate the "description" of some resources in this stack.
- `asg_name` - Name of the ASG to associate the alarm with.
- `notifications` - List of events to associate with the auto scaling notification.
- `adjustment_type` - Specifies the scaling adjustment.  Valid values are 'ChangeInCapacity', or 'ExactCapacity'.
- `scaling_adjustment` - The number of instances involved in a scaling action.
- `cooldown` - Seconds between auto scaling activities.
- `comparison_operator` - Arithmetic operation to use when comparing the thresholds. Valid values are 'GreaterThanOrEqualToThreshold', 'GreaterThanThreshold', 'LessThanThreshold' and 'LessThanOrEqualToThreshold'
- `evaluation_periods` - The number of periods over which data is compared to the specified threshold.
- `metric_name` - Name for the alarm's associated metric.
- `name_space` - The namespace for the alarm's associated metric.
- `period` - The period in seconds over which the specified statistic is applied.
- `statistic` - The statistic to apply to the alarm's associated metric.
- `threshold` - The value against which the specified statistic is compared.

### Usage ###

The usage examples assume a configured AWS provider is present in the calling template.

```js
module "scaling_policy" {
  source = "github.com/unifio/terraform-aws-asg//policy/absolute"

  stack_item_label = "ops"
  stack_item_fullname = "application"
  asg_name = "example_asg"
  adjustment_type = "ExactCapacity"
  scaling_adjustment = "4"
  cooldown = "300"
}
```

### Outputs ###

- `sns_arn` - Resource name of the Simple Notification Service topic.

## Percentage Policy Module ##

The `percentage` policy module sets up the policies, notifications and monitors to scale an auto scaling group by percentages of existing capacity.

### Input Variables ###

- `stack_item_label` - Short form identifier for this stack. This value is used to create the "Name" resource tag for resources created by this stack item, and also serves as a unique key for re-use.
- `stack_item_fullname` - Long form descriptive name for this stack item. This value is used to populate the "description" of some resources in this stack.
- `asg_name` - Name of the ASG to associate the alarm with.
- `notifications` - List of events to associate with the auto scaling notification.
- `adjustment_type` - Specifies the scaling adjustment.  Valid values are 'ChangeInCapacity', or 'ExactCapacity'.
- `scaling_adjustment` - The number of instances involved in a scaling action.
- `cooldown` - Seconds between auto scaling activities.
- `min_adjustment_step` - Minimum number of instances to be involved in a scaling adjustment based on percentage of capacity.
- `comparison_operator` - Arithmetic operation to use when comparing the thresholds. Valid values are 'GreaterThanOrEqualToThreshold', 'GreaterThanThreshold', 'LessThanThreshold' and 'LessThanOrEqualToThreshold'
- `evaluation_periods` - The number of periods over which data is compared to the specified threshold.
- `metric_name` - Name for the alarm's associated metric.
- `name_space` - The namespace for the alarm's associated metric.
- `period` - The period in seconds over which the specified statistic is applied.
- `statistic` - The statistic to apply to the alarm's associated metric.
- `threshold` - The value against which the specified statistic is compared.

### Usage ###

The usage examples assume a configured AWS provider is present in the calling template.

```js
module "scaling_policy" {
  source = "github.com/unifio/terraform-aws-asg//policy/percentage"

  stack_item_label = "ops"
  stack_item_fullname = "application"
  asg_name = "example_asg"
  adjustment_type = "PercentChangeInCapacity"
  scaling_adjustment = "4"
  cooldown = "300"
}
```

### Outputs ###

- `sns_arn` - Resource name of the Simple Notification Service topic.

## Examples

See the [examples](examples) directory for a complete set of example source files.

## License ##

Apache 2 Licensed. See LICENSE for full details.
