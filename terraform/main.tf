module "jenkins_kp" {
    source = "./key_pair"
    count = var.create_key_pair ? 1 : 0
}

resource "aws_iam_service_linked_role" "autoscaling" {
    aws_service_name = "autoscaling.amazonaws.com"
    description      = "A service linked role for autoscaling"
    custom_suffix    = var.region

    # Sometimes good sleep is required to have some IAM resources created before they can be used
    provisioner "local-exec" {
        command = "sleep 10"
    }
}

# ref: https://github.com/terraform-aws-modules/terraform-aws-autoscaling/tree/v8.0.0/examples
module "asg_sg" {
    source  = "terraform-aws-modules/security-group/aws"
    version = "~> 5.0"

    name        = "${local.name}-asg-sg"
    description = "jenkins asg security group"
    vpc_id      = module.vpc.vpc_id

    computed_ingress_with_source_security_group_id = [
        {
            rule                     = "http-80-tcp"
            source_security_group_id = module.alb.security_group_id
        }
    ]
    number_of_computed_ingress_with_source_security_group_id = 1
    egress_rules = ["all-all"]
}

module "jenkins-asg" {
    source  = "terraform-aws-modules/autoscaling/aws//examples/complete"
    version = "8.0.0"
    name            = "Jenkins-Production-ASG"
    use_name_prefix = false
    instance_name   = "jenkins-production"

    ignore_desired_capacity_changes = true

    min_size                  = 1
    max_size                  = 1
    desired_capacity          = 1
    wait_for_capacity_timeout = 0
    default_instance_warmup   = 300
    health_check_type         = "EC2"
    vpc_zone_identifier       = module.vpc.private_subnets
    service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

    # Traffic source attachment
    traffic_source_attachments = {
        ex-alb = {
            traffic_source_identifier = module.alb.target_groups["jenkins_asg"].arn
            traffic_source_type       = "elbv2" # default
        }
    }

    initial_lifecycle_hooks = [
        {
            name                 = "ExampleStartupLifeCycleHook"
            default_result       = "CONTINUE"
            heartbeat_timeout    = 60
            lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
            # This could be a rendered data resource
            notification_metadata = jsonencode({ "hello" = "world" })
        },
        {
            name                 = "ExampleTerminationLifeCycleHook"
            default_result       = "CONTINUE"
            heartbeat_timeout    = 180
            lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
            # This could be a rendered data resource
            notification_metadata = jsonencode({ "goodbye" = "world" })
        }
    ]

    instance_maintenance_policy = {
        min_healthy_percentage = 100
        max_healthy_percentage = 110
    }

    # Launch template
    launch_template_name        = "${local.name}-launch-template"
    launch_template_description = "Complete launch template example"
    update_default_version      = true

    image_id          = data.aws_ami.amazon_linux.id // NOTE: You cam use you pre configured ami here so no need to install Jenkins at each startup
    instance_type     = "t3.large"
    user_data         = data.template_file.jenkins_user_data.rendered
    ebs_optimized     = true
    enable_monitoring = true

    create_iam_instance_profile = true
    iam_role_name               = "${local.name}-iam-role"
    iam_role_path               = "/ec2/"
    iam_role_description        = "Complete IAM role example"
    iam_role_tags = {
        CustomIamRole = "Yes"
    }
    iam_role_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    }

    # # Security group is set on the ENIs below
    security_groups          = [module.asg_sg.security_group_id]

    block_device_mappings = [
        {
            # Root volume
            device_name = "/dev/xvda"
            no_device   = 0
            ebs = {
                delete_on_termination = true
                encrypted             = true
                volume_size           = 20
                volume_type           = "gp3"
            }
        }
    ]

    metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 32
        instance_metadata_tags      = "enabled"
    }

    network_interfaces = [
        {
            delete_on_termination = true
            description           = "eth0"
            device_index          = 0
            security_groups       = [module.asg_sg.security_group_id]
        },
        {
            delete_on_termination = true
            description           = "eth1"
            device_index          = 1
            security_groups       = [module.asg_sg.security_group_id]
        }
    ]

    placement = {
        availability_zone = "${local.region}b"
    }

    # Autoscaling can be added further
    # at this point of time our goal is to setup only one jenkins master node

}