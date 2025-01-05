resource "aws_cloudwatch_log_group" "frontend" {
  name              = "/ecs/frontend"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend_rds" {
  name              = "/ecs/backend-rds"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "backend_redis" {
  name              = "/ecs/backend-redis"
  retention_in_days = 7
}
