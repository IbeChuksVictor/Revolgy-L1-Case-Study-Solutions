# Task 1: Incident Response & Troubleshooting

## Incident Report: High CPUUsage on customer-frontend-app<br>

**Alert Details:**<br>
  - **Alert Type:** High CPU Usage
  - **Time:** 03:42 UTC
  - **Instance ID:** i-0a1b2c3d4e5f6g7h8
  - **Region:** us-east-1
  - **Metric:** CPUUtilization > 90% for 5 minutes
  - **Instance Type:** t3.micro
  - **Application:** customer-frontend-app
  - **Impact:** Increased latency observed in application response

**Potential Causes:**<br>
  - Increased Traffic Load - Sudden surge in users or traffic spikes may have overwhelmed the instance
  - Application Performance Issues - Inefficcient code, memory leaks, or excessive resource consumption.
  - Background Processes - Unexpected processes consuming the CPU resources.
  - Instance Type Limitation - The `t3.micro` instance has limited compute capacity, which may be insufficient for the current workload.
  - Malicious Activity - A potential security threat (eg DDoS Attack) causing high resource usage.

**Investigation Steps:**<br>
  1. Check to verify AWS CloudWatch Metrics or any third-Party monitoring tool in use:
      - Review CPU utilization trends before and after the alert.
      - Examine network traffic and request rates.
      - Analyze memory and disk usage to rule out bottlenecks.
      - Check relevant dashboards to inspect data for anomalies.
  
  2. SSH into the instance to perform real-time diagnostics:<br>
      - With the command:
        ```sh
        ssh -i key.pem ec2-user@<instance-public-ip>
        ```
      - To identify the processes with the most CPU usage, run:
        ```sh
        # outputs real-time data of CPU usage
        top -o %CPU 

        # Outputs snapshots of the top 10 processes consuming the most CPU
        ps aux --sort=-%cpu | head -10
        ```
      - To identify the processes with the most memory usage, run:
        ```sh
        # outputs real-time data of Memory usage
        top -o %MEM

        # Outputs snapshots of the top 10 processes consuming the most memory
        ps aux --sort=-%mem | head -10
        ```
  3. Check System Logs for Errors or Unusual patterns:<br>
      - For system logs run:  - 
        ```sh
        sudo journalctl -xe
        ```
      - For application logs (assuming logs in `var/log/application.log`), run:
        ```sh
        tail -n 10 /var/log/application.log
        ```
  4. Check Resource Limits and Traffic:<br>
      - To Check memory usage, run:
        ```sh
        free -h
        ```
      - To check disk space, run:
        ```sh
        df -h
        ```
      - To check active connections, run:
        ```sh
        netstat -tunapl
        ```
**Criteria for Escalation:**<br>
Escalation is necessary if:
  - The issue persists beyond initial troubleshooting.
  - The root cause points to an application bug that would require developer intervention.
  - Scaling the instance does not alleviate performance degradation.
  - There are Security threats or potential DDoS attacks are identified.