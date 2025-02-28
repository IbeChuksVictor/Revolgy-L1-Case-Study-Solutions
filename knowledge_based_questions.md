# Linux Administration (Basic CLI & System Management)

1. **Checking System Performance** (CPU & Memory Usage)
	- To check CPU and memory usage in real-time, run:
		```sh
		top
		
	  	# Then press `Shift` + `P` to sort the output by CPU usage
	 	# Press `Shift` + `M` to sort the output by memory usage
		```
		```sh
		
		ps aux
		# To get the static snapshot of all processes and their CPU and memory usage
		```
		```sh
		free -h
	  	# Used to check the system's memory usage in a human-readable format
		```

	- To identify the process consuming the most CPU, run
		```sh
		ps aux --sort=-%CPU | head -10 
		# Outputs snapshots of the 10 most CPU consuming processes in descending order

		top -o %CPU 
		# To get the most CPU and memory usage process in descending order in real-time
		```
---
2. **Managing Services**
	- To check if the service is running e.g. `nginx`, run:
		```sh
		sudo systemctl status nginx
		```
	- To restart a service, run:
		```sh
		sudo systemctl restart nginx
		```
---
3. **Log Analysis & Troubleshooting**
	- System logs and application logs can typically be found in the `/var/log` directory.
	- The `tail` command with the `-f` option will continuously watch for new log entries.
---
4. **User & Permissions Management**
	- To add a new Linux user you run these commands:
		```sh
		# Create a new user with home directory
		sudo useradd -m support_agent

		# Create user with additinal information such as default shell and comment
		sudo useradd -m -s /bin/bash -c "Support Agent" support_agent

		# Set password for the user
		sudo passwd support_agent
		```
	- To give the user administrative priviledges:
		```sh
		# Add user to wheel group (Amazon Linux is of the CentOS/RHEL distribution)
		sudo usermod -aG wheel support_agent
		```
---
# Networking & Cloud Infrastructure Basics
5. **Network Troubleshooting – Connectivity Issue**
	- Command to check if the server is reachable from another machine:
		```sh
		ping <ec2-instance-ip>
		```
	- Possible reasons why an instance might not be reacheable:
		- Security Group rules not allowing traffic on required ports
		- Network ACLs blocking traffic
		- Routing issues in the VPC
		- Instance firewall (iptables/firewalld) blocking connections
		- Application not running or not listening on expected port
		- Instance is in a private subnet without proper NAT/routing
		- Instance health issues (crashed, high load, out of resources)
		- DNS resolution problems if using domain name
		- Elastic IP not properly associated with the instance
		- Network interface issues on the instance
---
6. **Security Groups & Firewalls**
	- To check security group rules:
		```sh
		aws ec2 describe-security-groups --group-id <security-group-id>
		```
	- 
		```sh
		aws ec2 authorize-security-group-ingress \
    		--group-id <security-group-id> \
    		--protocol tcp \
    		--port 80 \
    		--cidr 0.0.0.0/0
		```
---
7. **DNS Resolution Issues**
	- To check if a domain name is resolving to correct IP address:
		```sh
		# Query DNS for A record
		dig <domain-name> A +short

		# Use nslookup to query the default DNS server for <domain-name>
		nslookup <domain-name>

		# Query the default DNS resolver for <domain-name>
		host <domain-name>>

		# Checks Google's public DNS server instead of the default resolver.
		dig @8.8.8.8 <domain-name> A

		# Retrieve  all DNS records
		dig <domain-name> ANY
		```
	- Commands that help troubleshoot DNS resolution issues:
		```sh
		# Check local DNS settings
		cat /etc/resolv.conf

		# Test DNS resolution with verbose output
		dig example.com +trace

		# Check DNS propagation globally
		# (would need to use online tools like dnschecker.org)

		# Check if the host file has entries
		cat /etc/hosts

		# Test reverse DNS
		dig -x IP_ADDRESS

		# Check if DNS port is accessible
		nc -zv DNS_SERVER 53
		```
---
8. **Infrastructure as Code (IaC) – Terraform Basics**
	- To check current Terraform state run:
		```sh
		# Show latest state of all resources Terraform is managing
		terraform show

		# Show current state
		terraform state list

		# Show detailed state for a specific resource
		terraform state show aws_instance.l1_case_study_instance
		```
	- To apply new changes run the following commands:
		```sh
		teraform init
		terraform plan
		terraform apply --auto-approve
		```
---
# System Maintenance & Best Practices
9. **Package Management & Software Updates**
	- To check for available update on a Debian-based system, run:
		```sh
		sudo apt list --upgradable
		```
	- To update a specific package (e.g., nginx):
		```sh
		# Update only nginx
		sudo apt install --only-upgrade nginx

		# Alternative method
		sudo apt update
		sudo apt install nginx
		```
---
10. **Schedules Tasks** (Cron Jobs)
	- To list existing scheduled tasks for a user:
		```sh
		# View current user's crontab
		crontab -l

		# View specific user's crontab (as root)
		sudo crontab -u <username> -l
		```
	- To add a cron job that restarts nginx at midnight:
		```sh
		# Edit current user's crontab
		crontab -e

		# Add the following line to restart nginx at midnight
		0 0 * * * /usr/bin/systemctl restart nginx

		# For system-wide cron (alternative)
		echo "0 0 * * * root /usr/bin/systemctl restart nginx" | sudo tee -a /etc/crontab
		```
---