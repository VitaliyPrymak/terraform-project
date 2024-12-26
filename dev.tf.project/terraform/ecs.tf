resource "aws_ecs_cluster" "main" {
  name = "main-ecs-cluster"

}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "frontend-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "084375565192.dkr.ecr.us-east-1.amazonaws.com/frontend-dev:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }

      ]
      environment = [
        { name = "BACKEND_RDS_URL", value = "http://rds-service:4000/test_connection/" },
        { name = "BACKEND_REDIS_URL", value = "http://redis-service:8000/test_connection/"}

      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/frontend"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "frontend_service" {
  name            = "frontend-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.frontend.arn
  launch_type     = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets          = [aws_subnet.public_1.id, aws_subnet.public_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true

  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }
  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.application_namespace.arn
    service {
      discovery_name = "frontend-service"
      port_name      = "frontend-port"
      client_alias {
        dns_name = "frontend-service"
        port     = 80
      }
    }
  }
}

resource "aws_ecs_task_definition" "backend_rds" {
  family                   = "backend-rds-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "rds-service"
      image     = "084375565192.dkr.ecr.us-east-1.amazonaws.com/backend-rds-dev:latest"
      essential = true
      portMappings = [
        {
          containerPort = 4000
          hostPort      = 4000
          name          = "rds-port"
        }
      ]
      environment = [
        { name = "DB_HOST", value = "main-db.cxo842e6snwn.us-east-1.rds.amazonaws.com" },
        { name = "DB_PORT", value = "5432" },
        { name = "DB_USER", value = "myuser" },
        { name = "DB_PASSWORD", value = "mypassword" },
        { name = "DB_NAME", value = "mydatabase" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend-rds"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "backend-rds"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "backend_rds_service" {
  name            = "rds-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_rds.arn
  launch_type     = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false

  }


  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.application_namespace.arn
    service {
      discovery_name = "rds-service"
      port_name      = "rds-port"
      client_alias {
        dns_name = "rds-service"
        port     = 4000
      }
    }
  }


}

resource "aws_ecs_task_definition" "backend_redis" {
  family                   = "backend-redis-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  task_role_arn      = aws_iam_role.ecs_task_role.arn # ДОДАНО ТУТ
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "backend_redis"
      image     = "084375565192.dkr.ecr.us-east-1.amazonaws.com/backend-redis-dev:latest"
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          name          = "redis-port"
        }
      ]
      environment = [
        { name = "REDIS_HOST", value = "redis-service.backend.local" },
        { name = "REDIS_PORT", value = "8000" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend-redis"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "backend_redis_service" {
  name            = "redis-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.backend_redis.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  enable_execute_command = true

  network_configuration {
    subnets          = [aws_subnet.private_1.id, aws_subnet.private_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.application_namespace.arn
    service {
      discovery_name = "redis-service"
      port_name      = "redis-port"
      client_alias {
        dns_name = "redis-service"
        port     = 8000
      }
    }
  }
}
