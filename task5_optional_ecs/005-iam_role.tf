resource "aws_iam_role" "L1_CS_ECS_task_execution_role" {
  name = "L1_CS_ECS_task_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "L1_CS_ECS_task_execution_role"
  }
}

# Attach the Amazon ECS task execution role policy to the role
resource "aws_iam_role_policy_attachment" "L1_CS_ECS_task_execution_role_policy" {
  role       = aws_iam_role.L1_CS_ECS_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}