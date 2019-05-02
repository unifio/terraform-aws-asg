# Standard ASG Example

## Configures providers
provider "aws" {
  region = var.region
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
  "Statement": [{
    "Effect": "Allow",
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "ec2.amazonaws.com"
    }
  }]
}
EOF

}

resource "aws_iam_role_policy" "policy_tagging" {
  name = "tagging"
  role = aws_iam_role.role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": [
      "ec2:CreateTags"
    ],
    "Resource": "*"
  }]
}
EOF

}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.stack_item_label}-${var.region}"
  role = aws_iam_role.role.name

  lifecycle {
    create_before_destroy = true
  }
}

## Creates ELB security group
resource "aws_security_group" "sg_elb" {
  description = "${var.stack_item_fullname} security group"
  name_prefix = "${var.stack_item_label}-elb-"
  vpc_id      = var.vpc_id

  tags = {
    application = var.stack_item_fullname
    Name        = "${var.stack_item_label}-elb"
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
  internal        = var.internal
  name            = var.stack_item_label
  security_groups = [aws_security_group.sg_elb.id]
  subnets         = split(",", var.subnets)

  tags = {
    application = var.stack_item_fullname
    Name        = var.stack_item_label
    managed_by  = "terraform"
  }

  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 2222
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 4
    timeout             = 5
    target              = "TCP:22"
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
  security_group_id = module.example.sg_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "sg_asg_elb" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_elb.id
  security_group_id        = module.example.sg_id

  lifecycle {
    create_before_destroy = true
  }
}

## Generates instance user data from a template
data "template_file" "user_data" {
  template = file("${path.module}/user_data.tpl")
}

## Provisions basic autoscaling group
module "example" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//group"
  source = "../../group"

  # Resource tags
  stack_item_fullname = var.stack_item_fullname
  stack_item_label    = var.stack_item_label

  # VPC parameters
  subnets = [split(",", var.subnets)]
  vpc_id  = var.vpc_id

  # LC parameters
  ami                           = var.ami
  ebs_vol_device_name           = var.ebs_vol_device_name
  ebs_vol_encrypted             = var.ebs_vol_encrypted
  ebs_vol_size                  = var.ebs_vol_size
  ebs_vol_snapshot_id           = var.ebs_vol_snapshot_id
  enable_monitoring             = var.enable_monitoring
  instance_based_naming_enabled = var.instance_based_naming_enabled
  instance_name_prefix          = var.instance_name_prefix
  instance_profile              = aws_iam_instance_profile.instance_profile.id
  instance_tags = {
    "env"  = var.env_tag
    "team" = var.team_tag
  }
  instance_type = var.instance_type
  key_name      = var.key_name
  root_vol_size = var.root_vol_size
  user_data     = data.template_file.user_data.rendered

  # ASG parameters
  desired_capacity      = var.desired_capacity
  load_balancers        = [aws_elb.elb.id]
  max_size              = var.max_size
  min_elb_capacity      = var.min_elb_capacity
  min_size              = var.min_size
  wait_for_elb_capacity = var.wait_for_elb_capacity
}

## Provisions autoscaling policies and associated resources
module "scale_up_policy" {
  # Example GitHub source
  #source = "github.com/unifio/terraform-aws-asg//policy"
  source = "../../policy"

  # Resource tags
  stack_item_fullname = var.stack_item_fullname
  stack_item_label    = "${var.stack_item_label}-up"

  # ASG parameters
  asg_name = module.example.asg_name

  # Notification parameters
  notifications = ["autoscaling:EC2_INSTANCE_LAUNCH_ERROR", "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"]

  # Monitor parameters
  adjustment_type     = "PercentChangeInCapacity"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  cooldown            = 300
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  period              = 120
  scaling_adjustment  = 30
  threshold           = 10
  treat_missing_data  = "breaching"
}

