
# Service Discovery for RDS
resource "aws_service_discovery_service" "rds_service" {
  name = "rds-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.backend_namespace.id
    dns_records {
      ttl  = 60
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

# Service Discovery for Frontend
resource "aws_service_discovery_service" "frontend_service" {
  name = "frontend-service"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.backend_namespace.id
    dns_records {
      ttl  = 60
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

resource "aws_service_discovery_private_dns_namespace" "backend_namespace" {
  name        = "backend-local"
  description = "Private DNS namespace for backend services"
  vpc = aws_vpc.main.id
  
}



