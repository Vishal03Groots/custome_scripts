#!/bin/bash

# Get the hostname of the server
HOSTNAME=$(hostname)

# Get the current date and time
DATE=$(date)

# Create a new file to store the server audit output
OUTPUT_FILE="server.txt"
touch "$OUTPUT_FILE"

# Print the hostname and date to the output file
echo "Server Audit Report for $HOSTNAME" >> "$OUTPUT_FILE"
echo "Generated on: $DATE" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the RAM usage and print it to the output file
echo "RAM Usage:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
free -m >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the disk usage and print it to the output file
echo "Disk Usage:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
df -h >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the list of users and print it to the output file
echo "List of Users:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/passwd >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the list of running services and print it to the output file
echo "Running Services:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
systemctl list-units --type=service --state=running >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the list of installed applications and their versions and print it to the output file
echo "Installed Applications:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
dpkg-query -l >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the list of open ports and print it to the output file
echo "Open Ports:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
netstat -tuln >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the OS name and version and print it to the output file
echo "Operating System:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/os-release >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the list of websites present on the server and print it to the output file
echo "Websites Present on the Server:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
ls /var/www/html/* >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Get the web server information and print it to the output file
echo "Web Server Information:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
apache2 -v >> "$OUTPUT_FILE" 2>&1
echo "" >> "$OUTPUT_FILE"

# Print the list of groups to the output file
echo "List of Groups:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
cat /etc/group >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Print the log entries to the output file
echo "Log Entries:" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
tail /var/log/syslog >> "$OUTPUT_FILE"
