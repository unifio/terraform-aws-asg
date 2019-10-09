## Unreleased

#### Consider Implementing:
* Consider coding `ebs_optimized` against list of [ebs-optimized instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html).
* Expose ephemeral block device support.
* Expose lifecycle hook support.
* Expose scheduling support.
* Added support for Autoscaling "StepScaling" policy.
* Break notifications out to support aggregation of groups and notifications
to a single SNS topic.
* Extend multi-part user_data mechanism to support more use cases.

## 0.4.0 (Oct 08, 2019)

#### IMPROVEMENTS / NEW FEATURES:
* Updated for Terraform v0.12

#### BACKWARDS INCOMPATIBILITIES / NOTES:
* Terraform versions earlier than 0.12.0 no longer supported.

## 0.3.0 (March 24, 2017)

#### BACKWARDS INCOMPATIBILITIES / NOTES:
* The following parameters were renamed:
 * `ebs_device_name` to `ebs_vol_device_name`
 * `ebs_snapshot_id` to `ebs_vol_snapshot_id`
* The `min_adjustment_magnitude` parameter for SimpleScaling policies has
been retired.

#### IMPROVEMENTS / NEW FEATURES:
* Conditional support for the following parameters:
 * `associate_public_ip_address`
 * `default_cooldown`
 * `desired_capacity`
 * `ebs_vol_encrypted`
 * `ebs_vol_size`
 * `enabled_metrics`
 * `enable_monitring`
 * `force_delete`
 * `instance_profile`
 * `key_name`
 * `placement_group`
 * `protect_from_scale_in`
 * `suspended_processes`
 * `termination_policies`
 * `root_vol_size`
 * `spot_price`
 * `user_data`
* Support for specifying multiple security groups in addition to the one
created by the module using the `security_groups` parameter.
* Support for `io1` root & EBS volumes.
* Support for EBS volume not not originating from a snapshot.
* Added `managed_by=terraform` tag to ASG managed instances.
* Instance `Name` tags can now be based on the instance-id by setting the
`instance_based_naming_enabled` parameter to **true**.
* Support for an arbitrary number of tags to be applied to each instance.

#### BUG FIXES:
* Fixed inconsistent tagging between `asg` and `asg_elb` resources

## 0.2.0 (May 16, 2016)

#### BACKWARDS INCOMPATIBILITIES / NOTES:
* Resources names updated in several places for standardization. Will cause
extra churn in existing environments.
* The built in egress security group rule has been remove from the module (see [here](https://github.com/unifio/terraform-aws-asg/compare/v0.1.2...v0.2.0#diff-776572ed86400784bb739b64a2cbcb00L14) and [here](https://github.com/unifio/terraform-aws-asg/compare/v0.1.2...v0.2.0#diff-adb68aea6eb2a951e65c8971444cee02L14)).
Be sure to declare your own egress rule when using the module (see [here](https://github.com/unifio/terraform-aws-asg/compare/v0.1.2...v0.2.0#diff-6f17df14965c642acbd9d68a62ea120eR148) and [here](https://github.com/unifio/terraform-aws-asg/compare/v0.1.2...v0.2.0#diff-7540fff78d0edcda5f9da593d378a2b3R82))

#### IMPROVEMENTS:
* Introduced deterministic conditional logic for the following scenarios:
 * Specification of an EBS snapshot to associate with the launch configuration.
 * Specification of ELB(s) to associate with the auto scaling group.
 * Specification of percentage based simple auto scaling policies.
* All variables explicitly typed per HashiCorp best practices.
* Added name prefixing to security group and launch configuration resources.
* Exposed `associate_public_ip_address` parameter on launch configuration.
* Exposed `placement_tenancy` parameter on launch configuration.
* Exposed root volume configuration parameters on launch configuration.
* Exposed EBS volume configuration parameters on launch configuration.
* Exposed `wait_for_capacity_timeout` parameter on auto scaling group.

## 0.1.2 (Apr 27, 2016)

#### BACKWARDS INCOMPATIBILITIES / NOTES:
* Changed the default value for `ebs_optimized` from `true` -> `false`. This
setting is more compatible with the majority of instance types.

#### IMPROVEMENTS:
* Name for `aws_launch_configuration`.
* Fixed name label for `aws_autoscaling_group`.
* Fixed name label for auto-scaling group's security group.

## 0.1.1 (Dec 1, 2015)

#### IMPROVEMENTS:
* Updated template_file usage for 0.6.7 to remove deprecation warnings [GH-9]
* Added ASG name to module outputs [GH-8]
* Added default Name tag to auto scaling groups [GH-6]

#### BUG FIXES:
* Updated lifecycle hooks to prevent dependency cycles during destroy [GH-5]
* Added proper lifecycle management to allow launch configuration updates [GH-2]
* Removed `sg-` from ASG security group name [GH-1]

## 0.1.0 (Oct 26, 2015)

* Initial Release
