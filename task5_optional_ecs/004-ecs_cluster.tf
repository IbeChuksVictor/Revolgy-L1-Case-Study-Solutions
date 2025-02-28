# Creates ECS cluster
resource "aws_ecs_cluster" "L1_CS_ECS_cluster" {
  name = "L1_CS_ECS_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "L1_CS_ECS_cluster"
  }
}

# Creates ECS task definition
resource "aws_ecs_task_definition" "L1_CS_ECS_task_definition" {
  family                   = "L1_CS_ECS_task_definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.L1_CS_ECS_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.L1_CS_cloudwatch_log_group.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "nginx"
        }
      }
    }
  ])

  tags = {
    Name = "L1_CS_ECS_task_definition"
  }
}

# Creates ECS service
resource "aws_ecs_service" "L1_CS_ECS_service" {
  name            = "L1_CS_ECS_service"
  cluster         = aws_ecs_cluster.L1_CS_ECS_cluster.id
  task_definition = aws_ecs_task_definition.L1_CS_ECS_task_definition.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  #iam_role        = aws_iam_role.L1_CS_ECS_task_execution_role.arn

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet1.id, aws_default_subnet.default_subnet2.id]
    security_groups  = [aws_security_group.L1_CS_ALB_SG.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.L1_CS_ALB_TG.arn
    container_name   = "nginx"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.L1_CS_ALB_LISTENER
  ]

  tags = {
    Name = "L1_CS_ECS_service"
  }
}