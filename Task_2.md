# Troubleshooting Playbook: High CPU Usage on AWS EC2 Instance

This playbook provides step-by-step instructions for identifying, troubleshooting, and resolving high CPU usage on an AWS EC2 instance. It also includes guidelines for escalation and long-term mitigation.

---

## 1. Verify the Alert
Before taking any action, confirm that the high CPU usage alert is valid.

### Steps:
1. **Log in to the AWS Management Console.**
2. Navigate to **EC2 > Instances** and locate the affected instance.
3. Check the **CloudWatch Metrics**:
   - Go to **CloudWatch > Metrics**.
   - Select the **EC2** namespace and find the affected instance.
   - Review the **CPUUtilization** metric to confirm high CPU usage (e.g., consistently above 80-90%).
4. Verify if the high CPU usage is expected (e.g., during peak traffic or scheduled tasks).

---

## 2. Collect Logs and Diagnostic Information
Gather relevant logs and metrics to diagnose the root cause.

### Steps:
1. **Connect to the EC2 Instance**:
   - Use SSH or Session Manager to access the instance.
		```sh
		ssh -i <KeyFile.pem> ec2-user@<InstancePublicIP>
		```
2. **Check Running Processes**:
   - Run `top -o %CPU` to check processes consuming high CPU.
   - Run `ps aux ---sort=-%cpu` to identify the process consuming high CPU.
   - Note the PID (Process ID) and user of the top-consuming processes.
3. **Check System Memory and Disk Usage**:
   - Run `free -h` to check system memory.
   - Run `df -h` to check disk usage.
4. **Check active connection and Traffic:**
   - Run `netstat -tunapl` to check for unusual network connections.
5. **Review System Logs**:
   - Check `/var/log/syslog` or `/var/log/messages` for any errors or warnings.
6. **Collect CloudWatch Logs**:
   - If configured, retrieve application logs from CloudWatch Logs.
7. **Check Application Logs**:
   - Review application-specific logs (e.g., `/var/log/nginx/error.log` for Nginx).

---

## 3. Take Short-Term Actions
Mitigate the immediate impact of high CPU usage.

### Steps:
1. **Kill or Restart Problematic Processes**:
   - If a specific process is causing the issue, consider terminating it:
     ```sh
     kill <PID>
     ```
   - If caused by a specific service, restart the service:
     ```
     sudo systemctl restart <service-name>
     ```
2. **Scale Horizontally**:
   - If the instance is part of an Auto Scaling Group, consider adding more instances to distribute the load.
3. **Adjust CPU Credits (for T-series Instances)**:
   - For instances that are burstable (e.g., t2, t3), monitor CPU credits and consider switching to unlimited mode if applicable.

---

## 4. Implement Long-Term Actions
Address the root cause to prevent recurrence.

### Steps:
1. **Optimize Application Code**:
   - Profile the application to identify inefficient code or queries.
   - Optimize database queries and reduce unnecessary computations.
2. **Upgrade Instance Type**:
   - Consider upgrading to a larger instance type with more CPU resources.
3. **Implement Auto Scaling**:
   - Configure Auto Scaling to automatically adjust the number of instances based on CPU usage.
4. **Implement Load Balancing:** 
   - Distribute traffic using AWS ELB.
5. **Set Up Alarms**:
   - Create CloudWatch Alarms to notify you of high CPU usage before it becomes critical.
6. **Monitor and Analyze Trends**:
   - Use CloudWatch dashboards to monitor CPU usage trends and identify patterns.

---

## 5. Escalation
If the issue cannot be resolved or requires additional expertise, escalate to the appropriate team.

### When to Escalate:
- High CPU usage persists despite mitigation efforts.
- The root cause is unclear or requires deeper investigation.
- The issue impacts critical production workloads.
- There is a potential security concern.
- There is a risk of business impact that requires higher-level intervention.

### Escalation Steps:
1. Notify the the relevant team - **DevOps/SRE Team**, **Cloud Infrastructure Team** or **Application Team**, using the internal communication tools.
2. Provide all collected logs, metrics, and steps taken so far using the internal incident reporting template.
3. If necessary, involve AWS Support by opening a support case with detailed information.

---

## 6. Documentation and Knowledge Sharing
After resolving the issue, document the findings and update the knowledge base.

### Steps:
1. Record the root cause and resolution steps.
2. Update the playbook with any new insights or best practices.
3. Share the findings with the team during the next incident review meeting.

---