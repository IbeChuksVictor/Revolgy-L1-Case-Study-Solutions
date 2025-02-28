# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "L1_CS_cloudwatch_log_group" {
	name = "/ecs/L1-CS-ECS-task"
	retention_in_days = 7

	tags = {
	  Name = "L1_CS_cloudwatch_log_group"
	}
}