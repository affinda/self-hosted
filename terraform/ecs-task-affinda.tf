resource aws_ecs_service affinda {
  name            = "${var.Environment}-affinda"
  cluster         = aws_ecs_cluster.affinda.id
  desired_count   = 1
  task_definition = aws_ecs_task_definition.affinda.arn
  deployment_minimum_healthy_percent = 0
  deployment_maximum_percent         = 100
  
}

resource aws_ecs_task_definition affinda {
  family = "${var.Environment}-affinda"
  memory = 0

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "celery_worker",
    "image": "${var.celery_worker_image}",
    "cpu": 0,
    "links": [
      "ocr:ocr",
      "libreoffice:libreoffice",
      "pdfkit:pdfkit",
      "redis:redis",
      "text_extraction:text_extraction",
      "inference:inference"
    ],
    "portMappings": [],
    "essential": true,
    "environment": [
        {
            "name": "PDFKIT_HOST",
            "value": "pdfkit"
        },
        {
            "name": "PDFKIT_PORT",
            "value": "5012"
        },
        {
            "name": "PATH",
            "value": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        },
        {
            "name": "APPS_MODE",
            "value": "CELERY_WORKER"
        },
        {
            "name": "OCR_HOST",
            "value": "ocr"
        },
        {
            "name": "OCR_PORT",
            "value": "5011"
        },
        {
            "name": "REDIS_HOST",
            "value": "redis"
        },
        {
            "name": "REDIS_PORT",
            "value": "6379"
        },
        {
            "name": "C_FORCE_ROOT",
            "value": "1"
        },
        {
            "name": "WEB_HOST",
            "value": "web"
        },
        {
            "name": "DB_USER",
            "value": "coreaffindauser"
        },
        {
            "name": "DJANGO_SECRET_KEY",
            "value": "${var.django_secret_key}"
        },
        {
            "name": "TEXT_EXTRACTION_HOST",
            "value": "text_extraction"
        },
        {
            "name": "TEXT_EXTRACTION_PORT",
            "value": "5010"
        },
        {
            "name": "DB_NAME",
            "value": "coreaffinda"
        },
        {
            "name": "DB_HOST",
            "value": "${var.db_host}"
        },
        {
            "name": "SENTRY_ENVIRONMENT",
            "value": "selfhosted"
        },
        {
            "name": "USE_ELASTICSEARCH",
            "value": "0"
        },
        {
            "name": "DJANGO_SETTINGS_MODULE",
            "value": "config.settings.selfhosted"
        },
        {
            "name": "PRELOAD_SMALL_MODELS",
            "value": "True"
        },
        {
            "name": "PYTHONUNBUFFERED",
            "value": "1"
        },
        {
            "name": "LIBRE_OFFICE_HOST",
            "value": "libreoffice"
        },
        {
            "name": "LIBRE_OFFICE_PORT",
            "value": "5013"
        },
        {
            "name": "DB_PASS",
            "value": "${var.db_pass}"
        },
        {
            "name": "CELERY_QUEUES",
            "value": "priority_1,priority_2,priority_3,priority_4"
        },
        {
            "name": "TORCHSERVE_HOST",
            "value": "inference"
        },
        {
            "name": "CELERY_DEBUG_LEVEL",
            "value": "INFO"
        },
        {
            "name": "DJANGO_SUPERUSER_PASSWORD",
            "value": "${var.django_superuser_password}"
        },
        {
            "name": "HOME",
            "value": "/opt/affinda"
        }
    ],
    "mountPoints": [
        {
            "sourceVolume": "affinda_shared",
            "containerPath": "/opt/shared/",
            "readOnly": false
        }
    ],
    "volumesFrom": [],
    "dependsOn": [
        {
            "containerName": "web",
            "condition": "HEALTHY"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_celery_worker"
        }
    }
},
{
    "name": "ocr",
    "image": "${var.ocr_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 5011,
            "hostPort": 5011,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_ocr"
        }
    },
    "healthCheck": {
        "command": [
            "curl",
            "--fail",
            "127.0.0.1:5011"
        ],
        "interval": 5,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 5
    }
},
{
    "name": "celery_beat",
    "image": "${var.celery_beat_image}",
    "cpu": 0,
    "links": [
        "ocr:ocr",
        "libreoffice:libreoffice",
        "pdfkit:pdfkit",
        "redis:redis",
        "text_extraction:text_extraction",
        "inference:inference"
    ],
    "portMappings": [],
    "essential": true,
    "environment": [
        {
            "name": "PDFKIT_HOST",
            "value": "pdfkit"
        },
        {
            "name": "PDFKIT_PORT",
            "value": "5012"
        },
        {
            "name": "PATH",
            "value": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        },
        {
            "name": "APPS_MODE",
            "value": "CELERY_BEAT"
        },
        {
            "name": "OCR_HOST",
            "value": "ocr"
        },
        {
            "name": "OCR_PORT",
            "value": "5011"
        },
        {
            "name": "REDIS_HOST",
            "value": "redis"
        },
        {
            "name": "REDIS_PORT",
            "value": "6379"
        },
        {
            "name": "C_FORCE_ROOT",
            "value": "1"
        },
        {
            "name": "WEB_HOST",
            "value": "web"
        },
        {
            "name": "DB_USER",
            "value": "coreaffindauser"
        },
        {
            "name": "DJANGO_SECRET_KEY",
            "value": "${var.django_secret_key}"
        },
        {
            "name": "TEXT_EXTRACTION_HOST",
            "value": "text_extraction"
        },
        {
            "name": "TEXT_EXTRACTION_PORT",
            "value": "5010"
        },
        {
            "name": "DB_NAME",
            "value": "coreaffinda"
        },
        {
            "name": "DB_HOST",
            "value": "${var.db_host}"
        },
        {
            "name": "SENTRY_ENVIRONMENT",
            "value": "selfhosted"
        },
        {
            "name": "USE_ELASTICSEARCH",
            "value": "0"
        },
        {
            "name": "DJANGO_SETTINGS_MODULE",
            "value": "config.settings.selfhosted"
        },
        {
            "name": "PRELOAD_SMALL_MODELS",
            "value": "True"
        },
        {
            "name": "PYTHONUNBUFFERED",
            "value": "1"
        },
        {
            "name": "LIBRE_OFFICE_HOST",
            "value": "libreoffice"
        },
        {
            "name": "LIBRE_OFFICE_PORT",
            "value": "5013"
        },
        {
            "name": "DB_PASS",
            "value": "${var.db_pass}"
        },
        {
            "name": "CELERY_QUEUES",
            "value": "priority_1,priority_2,priority_3,priority_4"
        },
        {
            "name": "TORCHSERVE_HOST",
            "value": "inference"
        },
        {
            "name": "CELERY_DEBUG_LEVEL",
            "value": "INFO"
        },
        {
            "name": "DJANGO_SUPERUSER_PASSWORD",
            "value": "${var.django_superuser_password}"
        },
        {
            "name": "HOME",
            "value": "/opt/affinda"
        }
    ],
    "mountPoints": [
        {
            "sourceVolume": "affinda_shared",
            "containerPath": "/opt/shared/",
            "readOnly": false
        }
    ],
    "volumesFrom": [],
    "dependsOn": [
        {
            "containerName": "web",
            "condition": "HEALTHY"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_celery_beat"
        }
    }
},
{
    "name": "web",
    "image": "${var.web_image}",
    "cpu": 0,
    "links": [
        "ocr:ocr",
        "libreoffice:libreoffice",
        "pdfkit:pdfkit",
        "redis:redis",
        "text_extraction:text_extraction",
        "inference:inference"
    ],
    "portMappings": [
        {
            "containerPort": 80,
            "hostPort": 80,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [
        {
            "name": "PDFKIT_HOST",
            "value": "pdfkit"
        },
        {
            "name": "PDFKIT_PORT",
            "value": "5012"
        },
        {
            "name": "PATH",
            "value": "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        },
        {
            "name": "APPS_MODE",
            "value": "WEB_SELFHOSTED"
        },
        {
            "name": "OCR_HOST",
            "value": "ocr"
        },
        {
            "name": "OCR_PORT",
            "value": "5011"
        },
        {
            "name": "REDIS_HOST",
            "value": "redis"
        },
        {
            "name": "REDIS_PORT",
            "value": "6379"
        },
        {
            "name": "WEB_HOST",
            "value": "web"
        },
        {
            "name": "DB_USER",
            "value": "coreaffindauser"
        },
        {
            "name": "DJANGO_SECRET_KEY",
            "value": "${var.django_secret_key}"
        },
        {
            "name": "TEXT_EXTRACTION_HOST",
            "value": "text_extraction"
        },
        {
            "name": "TEXT_EXTRACTION_PORT",
            "value": "5010"
        },
        {
            "name": "DB_NAME",
            "value": "coreaffinda"
        },
        {
            "name": "DB_HOST",
            "value": "${var.db_host}"
        },
        {
            "name": "SENTRY_ENVIRONMENT",
            "value": "selfhosted"
        },
        {
            "name": "USE_ELASTICSEARCH",
            "value": "0"
        },
        {
            "name": "DJANGO_SETTINGS_MODULE",
            "value": "config.settings.selfhosted"
        },
        {
            "name": "DISABLE_API_AUTHENTICATION",
            "value": "False"
        },
        {
            "name": "PYTHONUNBUFFERED",
            "value": "1"
        },
        {
            "name": "LIBRE_OFFICE_HOST",
            "value": "libreoffice"
        },
        {
            "name": "LIBRE_OFFICE_PORT",
            "value": "5013"
        },
        {
            "name": "DB_PASS",
            "value": "${var.db_pass}"
        },
        {
            "name": "TORCHSERVE_HOST",
            "value": "inference"
        },
        {
            "name": "DJANGO_SUPERUSER_PASSWORD",
            "value": "${var.django_superuser_password}"
        },
        {
            "name": "HOME",
            "value": "/opt/affinda"
        }
    ],
    "mountPoints": [
        {
            "sourceVolume": "affinda_shared",
            "containerPath": "/opt/shared/",
            "readOnly": false
        }
    ],
    "volumesFrom": [],
    "dependsOn": [
        {
            "containerName": "redis",
            "condition": "HEALTHY"
        },
        {
            "containerName": "ocr",
            "condition": "HEALTHY"
        },
        {
            "containerName": "text_extraction",
            "condition": "HEALTHY"
        },
        {
            "containerName": "pdfkit",
            "condition": "HEALTHY"
        },
        {
            "containerName": "libreoffice",
            "condition": "HEALTHY"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_web"
        }
    },
    "healthCheck": {
        "command": [
            "curl",
            "--fail",
            "http://localhost:80/admin"
        ],
        "interval": 15,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 240
    }
},
{
    "name": "text_extraction",
    "image": "${var.text_extraction_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 5010,
            "hostPort": 5010,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_text_extraction"
        }
    },
    "healthCheck": {
        "command": [
            "curl",
            "--fail",
            "127.0.0.1:5010"
        ],
        "interval": 5,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 5
    }
},
{
    "name": "pdfkit",
    "image": "${var.pdfkit_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 5012,
            "hostPort": 5012,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_pdfkit"
        }
    },
    "healthCheck": {
        "command": [
            "curl",
            "--fail",
            "127.0.0.1:5012"
        ],
        "interval": 5,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 5
    }
},
{
    "name": "inference",
    "image": "${var.inference_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 5014,
            "hostPort": 5014,
            "protocol": "tcp"
        },
        {
            "containerPort": 5015,
            "hostPort": 5015,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [
        {
            "name": "TS_MODEL_CONFIG",
            "value": "{\"headshot\":{\"1.0\":{\"defaultVersion\":true,\"minWorkers\":1,\"maxWorkers\":1}},\"resume\":{\"1.0\":{\"defaultVersion\":true,\"minWorkers\":1,\"maxWorkers\":1}},\"resume_multi\":{\"1.0\":{\"defaultVersion\":true,\"minWorkers\":1,\"maxWorkers\":1}}}"
        },
        {
            "name": "SENTRY_DSN_TYPE",
            "value": "DEV"
        },
        {
            "name": "TS_MANAGEMENT_ADDRESS",
            "value": "http://0.0.0.0:5015"
        },
        {
            "name": "SENTRY_ENVIRONMENT",
            "value": "inference_container_selfhosted"
        },
        {
            "name": "TS_INFERENCE_ADDRESS",
            "value": "http://0.0.0.0:5014"
        }
    ],
    "mountPoints": [],
    "volumesFrom": [],
    "stopTimeout": 3,
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_inference"
        }
    },
    "healthCheck": {
        "command": [
            "curl",
            "--fail",
            "127.0.0.1:5014/ping"
        ],
        "interval": 5,
        "timeout": 2,
        "retries": 10,
        "startPeriod": 60
    },
    "resourceRequirements": [
        {
            "value": "1",
            "type": "GPU"
        }
    ]
},
{
    "name": "libreoffice",
    "image": "${var.libreoffice_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 5013,
            "hostPort": 5013,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [],
    "volumesFrom": [],
    "hostname": "libreoffice",
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_libreoffice"
        }
    },
    "healthCheck": {
        "command": [
            "curl",
            "--fail",
            "127.0.0.1:5013/v3/api-docs"
        ],
        "interval": 5,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 5
    }
},
{
    "name": "redis",
    "image": "${var.redis_image}",
    "cpu": 0,
    "portMappings": [
        {
            "containerPort": 6379,
            "hostPort": 6379,
            "protocol": "tcp"
        }
    ],
    "essential": true,
    "environment": [],
    "mountPoints": [
        {
            "sourceVolume": "affinda_shared",
            "containerPath": "/opt/shared/",
            "readOnly": false
        }
    ],
    "volumesFrom": [],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${aws_cloudwatch_log_group.affinda.name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "affinda_redis"
        }
    },
    "healthCheck": {
        "command": [
            "redis-cli",
            "ping"
        ],
        "interval": 5,
        "timeout": 3,
        "retries": 10,
        "startPeriod": 5
    }
}
]
TASK_DEFINITION

  requires_compatibilities = ["EC2"]
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  volume  {
    name = "affinda_shared"
    host_path = "/opt/affinda/shared"
  }
}

