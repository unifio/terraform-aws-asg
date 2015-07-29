# AWS Autoscaling group

## Creates security group
resource "aws_security_group" "sg_asg" {
        name = "sg${var.stack_item_label}${var.stack_item_fullname}"
        description = "${var.stack_item_fullname} security group"
        vpc_id = "${var.vpc_id}"
        tags {
                application = "${var.stack_item_fullname}"
                Name = "${var.stack_item_label}-${var.stack_item_fullname}"
        }

        egress {
                cidr_blocks = ["0.0.0.0/0"]
                from_port = 0
                to_port = 0
                protocol = "-1"
        }
}

## Creates launch configuration
resource "aws_launch_configuration" "lc" {
        name = "lc-${var.stack_item_label}-${var.stack_item_fullname}"
        image_id = "${var.ami}"
        instance_type = "${var.instance_type}"
        iam_instance_profile = "${var.instance_profile}"
        key_name = "${var.key_name}"
        security_groups = ["${aws_security_group.sg_asg.id}"]
        enable_monitoring = "${var.enable_monitoring}"
        ebs_optimized = "${var.ebs_optimized}"
#        block_device_mapping =
        user_data = "${template_file.user_data.rendered}"
}

## Creates autoscaling group
resource "aws_autoscaling_group" "asg" {
        name = "asg-${var.stack_item_label}-${var.stack_item_fullname}"
        max_size = "${var.max_size}"
        min_size = "${var.min_size}"
        launch_configuration = "${aws_launch_configuration.lc.id}"
        health_check_grace_period = "${var.hc_grace_period}"
        health_check_type = "${var.hc_check_type}"
        force_delete = "${var.force_delete}"
        load_balancers = ["${split(",",var.load_balancers)}"]
        vpc_zone_identifier = ["${split(",",var.subnets)}"]
        tag {
                key = "application"
                value = "${var.stack_item_fullname}"
                propagate_at_launch = true
        }
        tag {
                key = "Name"
                value = "${var.stack_item_label}-${var.stack_item_fullname}"
                propagate_at_launch = true
        }
}


## Generates user data from a template
resource "template_file" "user_data" {
        filename = "${path.root}/templates/${var.user_data_template}"
        vars {
                hostname = "${var.stack_item_label}-${var.stack_item_fullname}"
                domain = "${var.domain}"
                region = "${var.region}"
                ssh_user = "${var.ssh_user}"
        }
}
