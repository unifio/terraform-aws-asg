Autoscaling Terraform Module
===========

A Terraform module to provide an Autoscaling deployment in an AWS VPC.


Prerequisites
----------------------

- Pre-configured AWS VPC

Requirements
----------------------

- Terraform 0.6.4 or newer
- AWS provider

Module Inputs
----------------------

- `stack_item_label` - Tag used in resource naming (i.e. ops).
- `stack_item_fullname` - Additional tag used in resource naming.
- `region` - EC2 region to be utilized.
- `vpc_id` - ID of the target VPC.
- `subnets` - List of available VPC subnets.
- `ami` - Pre-baked AMI.
- `instance_type` - EC2 instance type to be utilized.
- `instance_profile` - EC2 instance profile to be utilized.
- `key_name` - SSH key pair to be deployed to instances.
- `enable_monitoring` - Flag to enable detailed monitoring. Defaults to 'true'.
- `ebs_optimized` - Flag to enable EBS optimization. Defaults to 'true'.
- `max_size` - Maximum number of instances allowed by the autoscaling group.
- `min_size` - Minimum number of instance to be maintained by the autoscaling group.
- `hc_grace_period` - Time allowed after an instance comes into service before checking health.
- `hc_check_type` - Type of health check performed by the autoscaling group. Choice of 'ELB' or 'EC2'.
- `force_delete` - Flag to allow deletion of the autoscaling group without waiting for all instances in the pool to terminate. Defaults to 'false'.
- `load_balancers` - List of load balancer names to add to the autoscaling group.
- `user_data_template` - Path to instance user data template file. Defaults to 'user_data.tpl'.
- `domain` - Domain to be utilized in instance(s) FQDN.
- `ssh_user` - Default user to be configured for SSH with the selected key pair.

Usage
-----

Template

To use this template, you need to do the following:

1.) Set values for the input variables detailed above from a calling template. This template must include a configured AWS provider.

```
provider "aws" {
        region = "us-east-1"
		secret_key = "<secret_key>"
		access_key = "<access_key>"
}

module "autoscaling" {
        source = "github.com/unifio/terraform-aws-autoscaling"

# the following variables are required AWS objects that should exists in the
# aws account prior to execution of this infrastructure
        vpc_id = "vpc-0a74db6f"
        subnets = "subnet-8c3ebefb,subnet-965bfecf,subnet-0db42f68"
        load_balancers = "application-elb"
        instance_profile = "terraform"
        key_name = "ops"
## the following variables are to be populated at the discretion of the user
        domain = "unif.io"
        stack_item_label = "ops"
        stack_item_fullname = "application"
## if the Autoscaling group is configured for EBS optimization then
## individually EBS optimized instances will fail to launch.  		
        ebs_optimized = "false"
        ami = "ami-5b7b726b"
        instance_type = "t2.medium"
        max_size = "6"
        min_size = "2"
        hc_grace_period = "300"
        hc_check_type = "ELB"
        ssh_user = "centos"
}
```

2.) Use `terraform get` to pull in your module dependences and run a `terraform plan` execution to see if your input variables will result in the AWS resources you wanted.

```
terraform get -update
terraform plan -module-depth=-1
```

3.) Assuming the output of the plan looks good to you, you apply with with

```
terraform apply
```

Authors
=======

Created and maintained by [Unif.io, Inc.](https://github.com/unifio)

License
=======

Apache 2 Licensed. See LICENSE for full details.
