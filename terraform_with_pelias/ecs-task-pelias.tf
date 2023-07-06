
resource aws_service_discovery_service affinda_pelias {
  name = "${var.Environment}-affinda-pelias"

  dns_config {
    namespace_id = "${data.aws_service_discovery_dns_namespace.disco_zone.id}"
    dns_records {
      ttl = 10
      type = "A"
    }
    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 2
  }
}

resource aws_ecs_service affinda_pelias {
  name            = "${var.Environment}-affinda-pelias"
  cluster         = aws_ecs_cluster.affinda.id
  desired_count   = 1
  task_definition = aws_ecs_task_definition.affinda_pelias.arn
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100

  network_configuration {
    assign_public_ip = false
    security_groups = [data.aws_security_group.ecs_affinda.id]
    subnets = [local.PrivateSubnet[var.ECSHostAZ]]
  }

  service_registries {
    registry_arn = aws_service_discovery_service.affinda_pelias.arn
    container_name = "pelias_api"
  }

}

resource aws_ecs_task_definition affinda_pelias {
  family       = "${var.Environment}-affinda-pelias"
  memory       = 0
  network_mode = "awsvpc"
    
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "pelias_elasticsearch",
    "image": "${var.pelias_elasticsearch_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 9200,
            "hostPort": 9200,
            "protocol": "tcp"
        },
        {
            "containerPort": 9300,
            "hostPort": 9300,
            "protocol": "tcp"
        }
    ],
    "ulimits": [
        {
            "name" : "memlock",
            "softLimit" : -1,
            "hardLimit" : -1
        },
        {
            "name" : "nofile",
            "softLimit" : 65536,
            "hardLimit" : 65536
        }
    ],
    "linuxParameters": {
        "capabilities": {
            "add": ["IPC_LOCK"]
        }
    },
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_pelias_elasticsearch"
        }
    },
    "healthCheck": {
        "command": [
            "CMD",
            "curl",
            "--fail",
            "127.0.0.1:9200"
        ],
        "interval": 5,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 5
    }
},
{
    "name": "pelias_api",
    "image": "${var.pelias_api_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 4000,
            "hostPort": 4000,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [
        {
            "name": "PORT",
            "value": "4000"
        },
        {
            "name": "ELASTICSEARCH_HOST",
            "value": "9200"
        }
    ],
    "mountPoints": [
        {
            "sourceVolume": "pelias_config",
            "containerPath": "/code/pelias.json",
            "readOnly": false
        }
    ],
    "volumesFrom": [],
    "dependsOn": [
        {
            "containerName": "pelias_elasticsearch",
            "condition": "HEALTHY"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_pelias_api"
        }
    }
},
{
    "name": "pelias_placeholder",
    "image": "${var.pelias_placeholder_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 4100,
            "hostPort": 4100,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [
        {
            "name": "PORT",
            "value": "4100"
        }
    ],
    "mountPoints": [],
    "volumesFrom": [],
    "dependsOn": [
        {
            "containerName": "pelias_elasticsearch",
            "condition": "HEALTHY"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_pelias_placeholder"
        }
    }
},
{
    "name": "pelias_libpostal",
    "image": "${var.pelias_libpostal_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 4400,
            "hostPort": 4400,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "dependsOn": [
        {
            "containerName": "pelias_elasticsearch",
            "condition": "HEALTHY"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_pelias_libpostal"
        }
    }
}
]
TASK_DEFINITION

  requires_compatibilities = ["EC2"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  volume  {
    name = "pelias_config"
    host_path = "/opt/affinda/pelias.json"
  }
}

