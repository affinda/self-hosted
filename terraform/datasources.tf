#################################### NETWORK ###################################
# Service discovery zone is global to all services, not just Affinda, so create elsewhere and then datasource in
data aws_service_discovery_dns_namespace disco_zone {
  name = "${var.Environment}.discovery.yourcompanyname.com"
  type = "DNS_PRIVATE"
}

data aws_vpc VPC {
  filter {
    name = "tag:Environment"
    values = [var.Environment]
  }
}

data aws_subnet PrivateA {
  filter {
    name = "tag:Name"
    values = ["*Private A"]
  }
}

data aws_subnet PrivateB {
  filter {
    name = "tag:Name"
    values = ["*Private B"]
  }
}

data aws_subnet PrivateC {
  filter {
    name = "tag:Name"
    values = ["*Private C"]
  }
}

###################################### AMI #####################################
# AWS ECS image that has GPU support
data aws_ami latest_ecs_gpu {
most_recent = true
owners = ["591542846629"] # AWS

  filter {
      name   = "name"
      values = ["amzn2-ami-ecs-gpu-hvm-*-x86_64-ebs"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

################################# AWS Account #################################
data aws_caller_identity current {}
