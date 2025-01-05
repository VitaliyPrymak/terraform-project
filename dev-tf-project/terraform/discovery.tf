resource "aws_service_discovery_http_namespace" "application_namespace" {
  name        = "backend-local"
  description = "HTTP service discovery namespace"

}



