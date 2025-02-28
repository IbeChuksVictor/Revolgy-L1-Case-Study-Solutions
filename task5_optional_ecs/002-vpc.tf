# Create a default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Create default subnets
resource "aws_default_subnet" "default_subnet1" {
  availability_zone = "us-east-1a"

  tags = {
    Name = "Default subnet for us-east-1a"
  }
}

# Create default subnets
resource "aws_default_subnet" "default_subnet2" {
  availability_zone = "us-east-1b"

  tags = {
    Name = "Default subnet for us-east-1b"
  }
}
# Create a security group for ALB
resource "aws_security_group" "L1_CS_ALB_SG" {
  name        = "L1_CS_ALB_SG"
  description = "ALB Security Group"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "L1_CS_ALB_SG"
  }
}

# Create ingress rule to allow HTTP traffic to ALB
resource "aws_vpc_security_group_ingress_rule" "L1_CS_ALB_SG_http_ingress_rule" {
  security_group_id = aws_security_group.L1_CS_ALB_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Create an egress rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "L1_CS_ALB_SG_egress_rule" {
  security_group_id = aws_security_group.L1_CS_ALB_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Create a security group for ECS task
resource "aws_security_group" "L1_CS_ECS_SG" {
  name        = "L1_CS_ECS_SG"
  description = "ECS Security Group"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "L1_CS_ECS_SG"
  }
}

# Create ingress to allow HTTP traffic from ALB
resource "aws_vpc_security_group_ingress_rule" "L1_CS_ECS_SG_http_ingress_rule" {
  security_group_id            = aws_security_group.L1_CS_ECS_SG.id
  referenced_security_group_id = aws_security_group.L1_CS_ALB_SG.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

# Create an egress rule to allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "L1_CS_ECS_SG_egress_rule" {
  security_group_id = aws_security_group.L1_CS_ECS_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}