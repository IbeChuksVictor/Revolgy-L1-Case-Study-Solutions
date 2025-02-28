# Output the ALB DNS name
output "alb_dns_name" {
  value = aws_lb.L1_CS_ALB.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.L1_CS_ECS_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.L1_CS_ECS_service.name
}