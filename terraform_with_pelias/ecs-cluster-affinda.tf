################################################################################
#                              Shared Resources                                #
################################################################################
resource aws_cloudwatch_log_group affinda {
  name = "/ecs/affinda"

  tags = {
    Environment = var.Environment
    Application = "affinda"
  }
}

################################################################################
#                                 DATA SOURCES                                 #
################################################################################
data template_file userdata_affinda-ecs {
  template = file("userdata/affinda-ecs.txt")

  vars = {
    ecscluster = aws_ecs_cluster.affinda.name
  }
}

data aws_security_group ecs_affinda {
  name = "${var.Environment}-affinda"
}

data aws_iam_role ecs_affinda_hosts {
  name = "${var.Environment}_affinda_hosts"
}

data aws_iam_role ecs_affinda_tasks {
  name = "${var.Environment}_affinda_tasks"
}

data aws_iam_role ecs_task_execution_role {
  name = "ecsTaskExecutionRole"
}

################################################################################
#                                      ECS                                     #
################################################################################
resource aws_ecs_cluster affinda {
  name = "${var.Environment}-affinda"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

data template_cloudinit_config ecs_affinda {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.userdata_affinda-ecs.rendered
  }
}

# ASG for ECS hosts
resource aws_autoscaling_group ecs {
  lifecycle {
    create_before_destroy = true
  }

  name = "${var.Environment}_ecs_affinda"

  launch_template {
    id      = aws_launch_template.ecs_affinda.id
    version = "$Latest"
  }

  desired_capacity          = "1"
  termination_policies      = ["OldestLaunchConfiguration", "OldestInstance", "Default"]
  min_size                  = "1"
  max_size                  = "2" # Allow two for now just in case we need to pull a switcheroo without taking stuff offline too much
  vpc_zone_identifier       = [local.PrivateSubnet[var.ECSHostAZ]]
}

resource aws_launch_template ecs_affinda {
  name = "${var.Environment}_ecs_affinda"
  description = "Launch template for Affinda ECS hosts"

  instance_type = var.ECSHostSize
  image_id = data.aws_ami.latest_ecs_gpu.id

  iam_instance_profile {
    name = "${var.Environment}_affinda_hosts"
  }

  ebs_optimized = true

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      # This needs to be large enough for caches etc. Affinda say at least 70Gig, we'll go nearly double as storage is cheap and you get more IOPS
      volume_size = 150  
    }
  }

  vpc_security_group_ids = [
    data.aws_security_group.ecs_affinda.id
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.Environment}_ecs_affinda"
      Environment = var.Environment
      OS          = "linux"
      Application = "affinda"
      "PatchGroup" = "AmazonLinux2"
      #"PatchWindow" = "Sun_1800UTC"
    }
  }

  tag_specifications {
    resource_type = "volume"

    tags = {
      Name = "${var.Environment}_ecs_affinda"
      Environment = var.Environment
      Application = "affinda"
    }
  }

  user_data = data.template_cloudinit_config.ecs_affinda.rendered
}