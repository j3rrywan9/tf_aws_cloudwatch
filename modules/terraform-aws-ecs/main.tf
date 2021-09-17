resource "aws_ecs_capacity_provider" "cw_demo_capacity_provider" {
  name = "cw-demo-asg-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn = var.cw_demo_asg_arn

    managed_termination_protection = "DISABLED"
    
    managed_scaling {
      status = "ENABLED"
    }
  }
}

resource "aws_ecs_cluster" "cw_demo_cluster" {
  name = var.ecs_cluster_name

  capacity_providers = [
    aws_ecs_capacity_provider.cw_demo_capacity_provider.name,
  ]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.cw_demo_capacity_provider.name
    base              = 0
    weight            = 1
  }

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "cw_demo_taskdef" {
  family        = "cw-demo-task"
  task_role_arn = "arn:aws:iam::950350094460:role/ecsTaskExecutionRole"
  cpu           = 4096
  memory        = 16384
  # TODO: switch to awsvpc
  network_mode = "host"
  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = var.docker_image
      essential = true
      environment = [
        {
          name  = "SONAR_JDBC_URL"
          value = var.sonar_jdbc_url
        },
        {
          name  = "SONAR_JDBC_USERNAME"
          value = var.sonar_jdbc_username
        },
        {
          name  = "SONAR_JDBC_PASSWORD"
          value = var.sonar_jdbc_password
        },
      ]
      ulimits = [
        {
          name = "nofile"
          softLimit = 65536
          hardLimit = 65536
        }
      ]
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-region = var.aws_region
          awslogs-group = var.cloudwatch_log_group_name
        }
      }
      requiresCompatibilities = [
        "EC2"
      ]
    }
  ])
}

resource "aws_ecs_service" "cw_demo_service" {
  name = "cw-demo-service"

  cluster             = aws_ecs_cluster.cw_demo_cluster.id
  task_definition     = aws_ecs_task_definition.cw_demo_taskdef.arn
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.cw_demo_capacity_provider.name
    base              = 0
    weight            = 1
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}
