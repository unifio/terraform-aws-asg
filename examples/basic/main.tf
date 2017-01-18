# Basic ASG Example

## Configures providers
provider "aws" {
  region = "${var.region}"
}

## Creates IAM role
resource "aws_iam_role" "role" {
  name = "${var.stack_item_label}-${var.region}"
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
  name  = "${var.stack_item_label}-${var.region}"
  roles = ["${aws_iam_role.role.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "policy_monitoring" {
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
resource "aws_security_group_rule" "sg_asg_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.example.sg_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_asg_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${module.example.sg_id}"

  lifecycle {
    create_before_destroy = true
  }
}

## Generates instance user data from a template
data "template_file" "user_data" {
  template = "${file("../templates/user_data.tpl")}"

  vars {
    hostname = "${var.stack_item_label}"
    domain   = "example.org"
    region   = "${var.region}"
  }
}

## Provisions basic autoscaling group
module "example" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//group"
  source = "../../group"

  # Resource tags
  stack_item_label    = "${var.stack_item_label}"
  stack_item_fullname = "${var.stack_item_fullname}"

  # VPC parameters
  vpc_id  = "${var.vpc_id}"
  subnets = "${var.lan_subnet_ids}"
  region  = "${var.region}"

  # LC parameters
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  user_data        = "${data.template_file.user_data.rendered}"
  key_name         = "${var.key_name}"
  ebs_snapshot_id  = "expl-snap"

  # ASG parameters
  max_size = 1
  min_size = 1
}
