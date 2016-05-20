## Unreleased

#### Consider Implementing:
* Added support for Autoscaling "StepScaling" policy.
* Expose `metrics_granularity`?
* Auto-scaling schedule examples/modules.
* Consider coding `ebs_optimized` against list of [ebs-optimized instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html).
* Expose ephemeral block device support

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
* Changed the default value for `ebs_optimized` from `true` -> `false`. This setting is more compatible with the majority of instance types.

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
