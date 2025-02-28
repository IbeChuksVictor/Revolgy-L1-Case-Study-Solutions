# Specify the AWS provider and region
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.88.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create a default VPC
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# Create a security group
resource "aws_security_group" "L1_Case_Study_SG" {
  name        = "L1-Case-Study-Security-Group"
  description = "L1-Case-Study-Security-Group"
  vpc_id      = aws_default_vpc.default.id

  tags = {
    Name = "L1-Case-Study-SG"
  }
}

# Create ingress to allow SSH access
resource "aws_vpc_security_group_ingress_rule" "L1_Case_Study_SG_ssh_ingress_rule" {
  security_group_id = aws_security_group.L1_Case_Study_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create ingress to allow HTTP access
resource "aws_vpc_security_group_ingress_rule" "L1_Case_Study_SG_http_ingress_rule" {
  security_group_id = aws_security_group.L1_Case_Study_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Create an egress rule
resource "aws_vpc_security_group_egress_rule" "L1_Case_Study_SG_egress_rule" {
  security_group_id = aws_security_group.L1_Case_Study_SG.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# Create an EC2 instance
resource "aws_instance" "L1_Case_Study_Instance" {
  ami             = "ami-02a53b0d62d37a757"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.L1_Case_Study_SG.name]

  tags = {
    Name = "L1-Case-Study-Instance"
  }
}

# Output the public IP address of the instance
output "instance_public_ip" {
  value = aws_instance.L1_Case_Study_Instance.public_ip
}