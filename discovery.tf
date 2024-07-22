resource aws_service_discovery_private_dns_namespace dns_namespace {
  name = "testingServiceDiscovery"
  vpc  = "vpc-09b259b3d491399e6"
}

resource aws_service_discovery_service redis {
  name = "redis"

  dns_config {
    namespace_id = aws_service_discovery_private_dns_namespace.dns_namespace.id

    dns_records {
      ttl  = 60
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}