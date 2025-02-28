# Terraform Script Explanation<br>
 ##### This Terraform [script](./main.tf) provisions an AWS EC2 instance with the following specifications:
------
**Provider Configuration:** 
  - Specifies HashiCorp's AWS provider version 5.88.0
  - Sets up AWS region to us-east-1 (US East - N.Virginia).
------
**Default VPC:**
  - Uses the aws_default_vpc resource to reference the default VPC in your AWS account
  - Adds a "Default VPC" name tag for identification
------
**Security Group:**
  - Creates a security group that allows:
  - SSH access (port 22) from any IP address
  - HTTP access (port 80) from any IP address
  - All outbound traffic
------
**EC2 Instance:**
  - Provisions a t3.micro instance with:
  - Uses the AMI ID "ami-02a53b0d62d37a757" (Amazon Linux 2 in us-east-1)
  - Associates the security group created earlier
  - A tag with Name = "L1-Case-Study-Instance"
------
**Outputs:**
  - Provides the public IP address and instance ID for easy reference.
------
**To apply this configuration:**<br>
Run:
```sh
terraform init
terraform plan
terraform apply --auto-approve
```
------
**Usage Notes**<br>
When applied, this script will:
  - Reference the default VPC in your AWS account
  - Create a new security group within that VPC
  - Add inbound rules for SSH and HTTP traffic (only from within the VPC)
  - Add an outbound rule allowing all traffic
  - Launch a t3.micro EC2 instance with the specified AMI and security group
