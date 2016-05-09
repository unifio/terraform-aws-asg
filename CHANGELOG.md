## Unreleased

#### Consider Implementing:
* Added support for Autoscaling "StepScaling" policy.
* Expose `metrics_granularity`?
* Auto-scaling schedule examples/modules.
* De-duplicate similarities between basic and standard modules.
* Consider coding `ebs_optimized` against list of [ebs-optimized instances](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSOptimized.html).

## 0.1.3 (May 6, 2016)

#### IMPROVEMENTS:
* Added name prefixing to security group and launch configuration resources.
* Exposed `associate_public_ip_address` parameter on launch configuration.
* Exposed `placement_tenancy` parameter on launch configuration.
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
