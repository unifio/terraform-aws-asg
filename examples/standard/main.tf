# Standard ASG Example

## Configures providers
provider "aws" {
  region = "${var.region}"
}

provider "atlas" {
}

## Sources inputs from VPC remote state
resource "terraform_remote_state" "vpc" {
  backend = "atlas"

  config {
    name = "${var.vpc_stack_name}"
  }

  lifecycle {
    create_before_destroy = true
  }
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

## Creates ELB security group
resource "aws_security_group" "sg_elb" {
  name_prefix = "${var.stack_item_label}-elb-"
  description = "Standard ASG example ELB"
  vpc_id      = "${terraform_remote_state.vpc.output.vpc_id}"

  tags {
    Name        = "${var.stack_item_label}-elb"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }

  lifecycle {
    create_before_destroy = true
  }

  # Allow HTTP traffic
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

## Creates ELB
resource "aws_elb" "elb" {
  security_groups           = ["${aws_security_group.sg_elb.id}"]
  subnets                   = ["${split(",",terraform_remote_state.vpc.output.lan_subnet_ids)}"]
  internal                  = "${var.internal}"
  cross_zone_load_balancing = "${var.cross_zone_lb}"
  connection_draining       = "${var.connection_draining}"

  tags {
    Name        = "${var.stack_item_label}"
    application = "${var.stack_item_fullname}"
    managed_by  = "terraform"
  }

  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 4
    timeout             = 5
    target              = "TCP:8080"
    interval            = 30
  }

  lifecycle {
    create_before_destroy = true
  }
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

resource "aws_security_group_rule" "sg_asg_elb" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.sg_elb.id}"
  security_group_id        = "${module.example.sg_id}"

  lifecycle {
    create_before_destroy = true
  }
}

## Generates instance user data from a template
resource "template_file" "user_data" {
  template = "${file("../templates/user_data.tpl")}"

  vars {
    hostname = "${var.stack_item_label}"
    domain   = "example.org"
    region   = "${var.region}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

## Provisions basic autoscaling group
module "example" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//group/standard"
  source = "../../group/standard"

  # Resource tags
  stack_item_label    = "${var.stack_item_label}"
  stack_item_fullname = "${var.stack_item_fullname}"

  # VPC parameters
  vpc_id  = "${terraform_remote_state.vpc.output.vpc_id}"
  subnets = "${terraform_remote_state.vpc.output.lan_subnet_ids}"
  region  = "${var.region}"

  # LC parameters
  ami              = "${var.ami}"
  instance_type    = "${var.instance_type}"
  instance_profile = "${aws_iam_instance_profile.instance_profile.id}"
  user_data        = "${template_file.user_data.rendered}"
  key_name         = "${var.key_name}"

  # ASG parameters
  max_size         = "${var.cluster_max_size}"
  min_size         = "${var.cluster_min_size}"
  min_elb_capacity = "${var.min_elb_capacity}"
  load_balancers   = "${aws_elb.elb.id}"
}

## Provisions autoscaling policies and associated resources
module "scale_up_policy" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//policy/percentage"
  source = "../../policy/percentage"

  # Resource tags
  stack_item_label    = "${var.stack_item_label}-up"
  stack_item_fullname = "${var.stack_item_fullname}"

  # ASG parameters
  asg_name = "${module.example.asg_name}"

  # Notification parameters
  notifications = "autoscaling:EC2_INSTANCE_LAUNCH_ERROR,autoscaling:EC2_INSTANCE_TERMINATE_ERROR"

  # Monitor parameters
  scaling_adjustment       = 30
  cooldown                 = 300
  min_adjustment_magnitude = 2
  comparison_operator      = "GreaterThanOrEqualToThreshold"
  evaluation_periods       = 2
  metric_name              = "CPUUtilization"
  period                   = 120
  threshold                = 10
}

module "scale_down_policy" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//policy/absolute"
  source = "../../policy/absolute"

  # Resource tags
  stack_item_label    = "${var.stack_item_label}-down"
  stack_item_fullname = "${var.stack_item_fullname}"

  # ASG parameters
  asg_name = "${module.example.asg_name}"

  # Notification parameters
  notifications = "autoscaling:EC2_INSTANCE_LAUNCH_ERROR,autoscaling:EC2_INSTANCE_TERMINATE_ERROR"

  # Monitor parameters
  adjustment_type     = "ChangeInCapacity"
  scaling_adjustment  = 2
  cooldown            = 300
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  period              = 120
  threshold           = 10
}
