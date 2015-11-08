# Basic ASG Example

## Configures providers
provider "aws" {
  region = "${var.region}"
}
provider "atlas" {}

## Sources inputs from VPC remote state
resource "terraform_remote_state" "vpc" {
  backend = "atlas"

  config {
    name = "${var.organization}/${var.vpc_stack_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Creates IAM role
resource "aws_iam_role" "role" {
  name = "${var.stack_item_label}-${var.region}-example"
  path = "/"

  lifecycle {
    create_before_destroy = true
  }

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
         "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.stack_item_label}-${var.region}-example"
  roles = ["${aws_iam_role.role.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "logs" {
    name = "monitoring"
    role = "${aws_iam_role.role.id}"

    lifecycle {
      create_before_destroy = true
    }

    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:*"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

## Adds security group rules
resource "aws_security_group_rule" "ssh" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = ["${terraform_remote_state.vpc.output.lan_access_cidr}"]
  security_group_id = "${module.example.sg_id}"

  lifecycle {
    create_before_destroy = true
  }
}

## Generates instance user data from a template
resource "template_file" "user_data" {
  filename = "../templates/user_data.tpl"

  vars {
    hostname = "${var.stack_item_label}-example"
    domain = "example.org"
    region = "${var.region}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Provisions basic autoscaling group
module "example" {
  source = "github.com/unifio/terraform-aws-asg//group/basic"

  # Resource tags
  stack_item_label = "${var.stack_item_label}"
  stack_item_fullname = "${var.stack_item_fullname}"

  # VPC parameters
  vpc_id = "${terraform_remote_state.vpc.output.vpc_id}"
  subnets = "${terraform_remote_state.vpc.output.lan_subnet_ids}"
  region = "${var.region}"

  # LC parameters
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  user_data = "${template_file.user_data.rendered}"
  key_name = "${var.key_name}"

  # ASG parameters
  max_size = "${var.cluster_max_size}"
  min_size = "${var.cluster_min_size}"
}
