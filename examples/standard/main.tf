# Standard ASG Example

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
}

## Creates IAM role
resource "aws_iam_role" "role" {
  name = "${var.stack_item_label}-${var.region}-example"
  path = "/"
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
}

resource "aws_iam_role_policy" "logs" {
    name = "monitoring"
    role = "${aws_iam_role.role.id}"
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

## Creates ELB security group
resource "aws_security_group" "sg_elb" {
  name = "sg-${var.stack_item_label}-example"
  description = "Standard ASG example ELB"
  vpc_id = "${terraform_remote_state.vpc.output.vpc_id}"

  tags {
    Name = "${var.stack_item_label}-example-elb"
    application = "${var.stack_item_fullname}"
    managed_by = "terraform"
  }

  # Allow HTTP traffic
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

## Creates ELB
resource "aws_elb" "elb" {
  security_groups = ["${aws_security_group.sg_elb.id}"]
  subnets = ["${split(",",terraform_remote_state.vpc.output.lan_subnet_ids)}"]
  internal = "${var.internal}"
  cross_zone_load_balancing = "${var.cross_zone_lb}"
  connection_draining = "${var.connection_draining}"

  tags {
    Name = "${var.stack_item_label}-example"
    application = "${var.stack_item_fullname}"
    managed_by = "terraform"
  }

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 5
    unhealthy_threshold = 4
    timeout = 5
    target = "TCP:8080"
    interval = 30
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Adds security group rules
resource "aws_security_group_rule" "elb" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.sg_elb.id}"
  security_group_id = "${module.example.sg_id}"
}

## Generates instance user data from a template
resource "template_file" "user_data" {
  filename = "../templates/user_data.tpl"

  vars {
    hostname = "${var.stack_item_label}-example"
    domain = "example.org"
    region = "${var.region}"
  }
}

## Provisions basic autoscaling group
module "example" {
  source = "../../group/standard"

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
  min_elb_capacity = "${var.min_elb_capacity}"
  load_balancers = "${aws_elb.elb.id}"
}
