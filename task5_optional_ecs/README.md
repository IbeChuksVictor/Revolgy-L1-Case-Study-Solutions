# ECS Deployment Troubleshooting Guide

## Issue 1: ECS Tasks Stuck in PENDING State

### Symptoms
- Tasks show as `PENDING` in the ECS console
- No tasks reach RUNNING state
- Service events might show "service unable to place task"

### Potential Causes
1. **Insufficient Resources**: Not enough CPU/memory in the cluster for task placement
2. **Network Configuration Issues**: Subnets might not have internet access or proper routing
3. **Security Group Problems**: Missing required outbound rules
4. **IAM Permissions**: Insufficient permissions for the task execution role
5. **Service Quota Limits**: Reached AWS limits for VPC ENIs or IP addresses

### Troubleshooting Steps

1. **Check ECS Service Events**:
   ```bash
   aws ecs describe-services --cluster L1_CS_ECS_cluster --services L1_CS_ECS_service
   ```
   Look for placement errors in the events section

2. **Verify Network Configuration**:
   - Ensure subnets have internet gateway attached (for public subnets)
   - Check route tables associated with the subnets
   - Verify assign_public_ip is true for tasks in public subnets
   ```bash
   aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=<subnet-id>"
   ```

3. **Validate Security Groups**:
   - Ensure outbound traffic is allowed (port 443 for ECR pulls)
   - Confirm proper inbound rules
   ```bash
   aws ec2 describe-security-groups --group-ids <security-group-id>
   ```

4. **Check IAM Role Permissions**:
   - Verify the task execution role has proper policies
   - Ensure the role can be assumed by the ECS service
   ```bash
   aws iam get-role --role-name L1_CS_ECS_task_execution_role
   aws iam list-attached-role-policies --role-name L1_CS_ECS_task_execution_role
   ```

5. **Check CloudTrail Logs** for permission errors:
   ```bash
   aws cloudtrail lookup-events --lookup-attributes AttributeKey=EventName,AttributeValue=RunTask
   ```

### Resolution Steps
- Add necessary permissions to the IAM role
- Modify security group rules as needed
- Verify subnet configuration and update as required
- Increase task resources or add capacity to the cluster
- Modify network configuration in the ECS service

## Issue 2: ALB Health Checks Failing

### Symptoms
- Target group shows instances as unhealthy
- ALB returns 5xx errors
- The page doesn't load despite tasks running

### Potential Causes
1. **Health Check Configuration**: Incorrect path, port, or threshold settings
2. **Container Not Responding**: Application errors or not listening on expected port
3. **Network Path Issues**: Security groups not allowing health check traffic
4. **Application Errors**: Container starting but application crashing or misconfigured

### Troubleshooting Steps

1. **Check Target Group Health Status**:
   ```bash
   aws elbv2 describe-target-health --target-group-arn arn:aws:elasticloadbalancing:us-east-1:xxxx:targetgroup/L1-CS-ALB-TG/xxxx
   ```

2. **Review Health Check Configuration**:
   ```bash
   aws elbv2 describe-target-groups --target-group-arns arn:aws:elasticloadbalancing:us-east-1:xxxx:targetgroup/L1-CS-ALB-TG/xxxx
   ```
   Verify the health check path matches the application's health endpoint

3. **Examine Security Group Rules**:
   - Ensure ALB security group can reach ECS tasks on the health check port
   - Check that ECS tasks allow inbound from the ALB
   ```bash
   aws ec2 describe-security-group-rules --filters "Name=group-id,Values=<security-group-id>"
   ```

4. **Check Container Logs** for application errors:
   ```bash
   aws logs get-log-events --log-group-name /ecs/L1-CS-ECS-task --log-stream-name nginx/<container-id>
   ```

5. **Test Health Check Directly** (if accessible):
   ```bash
   curl -v http://container-ip:80/
   ```

### Resolution Steps
- Adjust health check settings (path, timeout, thresholds)
- Fix application to respond properly to health checks
- Update security group rules to allow health check traffic
- Check container configuration (correct port exposures)
- Debug application issues via logs

## Issue 3: Service Deployment Failures

### Symptoms
- New deployments fail to complete
- Old tasks are stopped but new ones don't start successfully
- Deployment shows as "in progress" for extended periods

### Potential Causes
1. **Container Pull Failures**: Issues accessing container image
2. **Task Definition Issues**: Misconfiguration in the task definition
3. **Service Auto Scaling Problems**: Scaling policies misconfigured
4. **Resource Constraints**: Not enough memory/CPU for new deployment
5. **Rollback Issues**: Failed to roll back after deployment errors

### Troubleshooting Steps

1. **Check Deployment Status**:
   ```bash
   aws ecs describe-services --cluster L1_CS_ECS_cluster --services L1_CS_ECS_service