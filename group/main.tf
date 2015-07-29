# AWS Autoscaling group

## Creates security group
resource "aws_security_group" "sg_asg" {
        name = "sg-${var.app_label}-${var.app_name}"
        description = "${var.app_name} security group"
        vpc_id = "${var.vpc_id}"
        tags {
                application = "${var.app_name}"
                Name = "${var.app_label}-${var.app_name}"
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
        name = "lc-${var.app_label}-${var.app_name}"
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
        name = "asg-${var.app_label}-${var.app_name}"
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
                value = "${var.app_name}"
                propagate_at_launch = true
        }
        tag {
                key = "Name"
                value = "${var.app_label}-${var.app_name}"
                propagate_at_launch = true
        }
}


## Generates user data from a template
resource "template_file" "user_data" {
        filename = "${path.root}/templates/${var.user_data_template}"
        vars {
                hostname = "${var.app_label}-${var.app_name}"
                domain = "${var.domain}"
                ssh_user = "${var.ssh_user}"
        }
}
